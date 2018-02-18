+++
title = "Output the Unity console to file"
draft = false
date = "2016-06-05T00:00:00+00:00"
updated = "2017-01-14T00:00:00+00:00"
image = "/images/tutorials/unityFileDebug/screenshot.png"
categories = ["unity","tutorial","asset"]
author = "Joel Kuntz"
class = "blog"
+++

Unity's built in console is not bad for development, but it could use some improvement. For me filtering and saving them seemed natural and thus I set out to see what I could find. Upon realizing there wasn't exactly what I was looking for that was open source I decided to make it.

<!--more-->

In this mini tutorial we will go over the how this was made in hopes to teach you something, and gain interest in collaboration. I started [this project](https://github.com/Sacred-Seed-Studio/Unity-File-Debug) with a few goals in mind.

1. Output Unity debug info to log files
2. A nice web interface to view the logs
  - HTML5
  - No external dependencies
  - Searchable via message, stacktrace, timestamp, logtype
  - Filterable by logtype
3. Be able to drop it into existing projects

To start this problem lets begin with 3. We want to be able to use this in existing projects to get the benefits of 1 and 2. I expect most people will use Unity's built in [Debug Class](https://docs.unity3d.com/ScriptReference/Debug.html) by default. To make this happen we will make a static class that wrap's Unity's Debug static functions.

```c#
public static class Debug
{
    public static void Log(object message)
    {
        UnityEngine.Debug.Log(message);
    }
    public static void Log(object message, Object context)
    {
        UnityEngine.Debug.Log(message, context);
    }
    //Continued for rest of functions & signatures...
}
```

After wrapping all of the functions, now whenever we use any of the `Debug` functions they will come through our class. From here we can start extending our wrapper functions with more functionality. We want to be able to filter by different log types so let's start there. The default Debug class has a few different types

- Log
- Warning
- Error
- Exception
- Assert

This is a good start, but doesn't provide enough when we want to filter more specificly. Let's make an enumeration of all the different Log types we want.

```c#
public enum DLogType
{
    Assert,
    Error,
    Exception,
    Warning,
    System,
    Log,
    AI,
    Audio,
    Content,
    Logic,
    GUI,
    Input,
    Network,
    Physics
}
```

Now let's add these types into our Debug class, but we must ensure we set defaults so we can use the same function signatures as the built in Debug class. To do that we do something like so

```c#
public static void Log(object message, DLogType type = DLogType.Log)
{
    UnityEngine.Debug.Log("[" + type + "] " + message);
}
```

By prepending each message with a consistent string `[DLogType]` will make it easier for us to parse later. We now must consider how we are going to save these to a file and in what format. Given we want to have a website log viewer it only makes sense to use JSON as the format. After reading through some C# and Unity documentation we find that we can hook into Unity's logging and call our own method whenever the built in Debug.Log functions are called.

```c#
public class UnityFileDebug : MonoBehaviour
{
    void OnEnable()
    {
        Application.logMessageReceived += HandleLog;
    }
    void OnDisable()
    {
        Application.logMessageReceived -= HandleLog;
    }
    void HandleLog(string logString, string stackTrace, LogType type)
    {
        //Structure our log into JSON here
    }
}
```

We now want to structure these logs into JSON format, and luckily for us Unity recently released a serializer which will take care of the bulk of our work. We will make a class to help the serializer with the format we want. Note here we use small key names to keep the outputted log file smaller.

```c#
[System.Serializable]
public class LogJSON
{
    public string t;  //type
    public string tm; //time
    public string l;  //log
    public string s;  //stack
}
```

Now we have what we need to structure our JSON we can structure our logs to write to a file. The observant documentation reader will have noticed that the built in Assert and Exception functions had different signatures that didn't support a message so we must account for that.

```c#
void HandleLog(string logString, string stackTrace, LogType type)
{
    LogJSON j = new LogJSON();
    if (type == LogType.Assert)
    {
        j.t = "Assert";
        j.l = logString;
    }
    else if (type == LogType.Exception)
    {
        j.t = "Exception";
        j.l = logString;
    }
    else
    {
        int end = logString.IndexOf("]");
        j.t = logString.Substring(1, end - 1);
        j.l = logString.Substring(end + 2);
    }

    j.s = stackTrace;
    j.tm = System.DateTime.Now.ToString("yyyy.MM.dd.HH.mm.ss");
}
```

Next we need to actually write this to a file. We want to create a JSON array of objects (the object matches up to the LogJSON class). We will use the `System.IO.StreamWriter` API to write to a file, we will Open and Close the stream in our `OnEnable()` and `OnDisable()` functions. We also create the helper function `UpdateFilePath()` to format a proper path with our filename. We also add the fileWriter to the end of `HandleLog` to save each log as it comes in.

```c#
public class UnityFileDebug : MonoBehaviour
{
    public bool useAbsolutePath = true;
    public string fileName = "MyGame";

    public string absolutePath = "/home/yourUsername/UnityLogs";

    public string filePath;
    public string filePathFull;
    public int count = 0;

    System.IO.StreamWriter fileWriter;

    void OnEnable()
    {
        UpdateFilePath();
        if (Application.isPlaying)
        {
            count = 0;
            fileWriter = new System.IO.StreamWriter(filePathFull, false);
            fileWriter.AutoFlush = true;
            fileWriter.WriteLine("[");
            Application.logMessageReceived += HandleLog;
        }
    }

    void OnDisable()
    {
        if (Application.isPlaying)
        {
            Application.logMessageReceived -= HandleLog;
            fileWriter.WriteLine("\n]");
            fileWriter.Close();
        }
    }

    public void UpdateFilePath()
    {
        filePath = useAbsolutePath ? absolutePath : Application.persistentDataPath;
        filePathFull = System.IO.Path.Combine(filePath, fileName + "." +
            System.DateTime.Now.ToString("yyyy.MM.dd.HH.mm.ss") + ".json");
    }

    void HandleLog(string logString, string stackTrace, LogType type)
    {
        //... same as above

        fileWriter.Write((count == 0 ? "" : ",\n") + JsonUtility.ToJson(j));
        count++;
    }
}
```

Now we should have the base functionality we need. Make a new GameObject and attach the `UnityFileDebug` script to it, as well as a new script testing out our new `Debug.Log` functionality in an `Update()`.

```c#
using UnityEngine;

public class DebugTester : MonoBehaviour
{
    void Update () { Debug.Log("AI Has gone rogue", DLogType.AI); }
}
```

Congratulations, if you've followed along you now have the basics of logging out to a file. I didn't intend to cover everything I've already implemented, but rather show you the method I used to develop this project. I hope if you like this style you will use it and even contribute to the project. Now that you have your logs in JSON format you can use various tools to view and filter them. I've written an HTML page in the project which you can demo [here](http://www.sacredseedstudio.com/Unity-File-Debug/). You could also use a command line tool like [jq](https://stedolan.github.io/jq/), or even languages such as node.js or python.

<img alt="HTML viewer" src="/images/tutorials/unityFileDebug/screenshot.png">

I've included a list of other interesting Unity Console tutorials/scripts below if this is only starting the gears in your head.

- [alanzucconi.com console-debugging-in-unity-made-easy](http://www.alanzucconi.com/2015/08/26/console-debugging-in-unity-made-easy/)
- [Unity Wiki - Scrolling ingame console](http://wiki.unity3d.com/index.php?title=DebugConsole)
- [mminer's Console.cs - another ingame console](https://gist.github.com/mminer/975374)
- [kreso22's Unity-3D-Debug-console-with-color](https://github.com/kreso22/Unity-3D-Debug-console-with-color.)
- [Pimp my Debug.Log](http://www.tallior.com/pimp-my-debug-log/)