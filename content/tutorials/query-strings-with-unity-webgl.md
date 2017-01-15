+++
draft = false
date = "2016-11-03T00:00:00+00:00"
updated = "2017-01-14T00:00:00+00:00"
image = ""
categories = ["tutorial","unity","webgl"]
author = "Joel Kuntz"
title = "Query Strings (Parameters) with Unity WebGL"

+++

A [query string](https://en.wikipedia.org/wiki/Query_string) (also called query parameters) is a way to pass data through the URL into a webpage directly. They can be used to perform tasks on a webpage, such as automatically filling out a form, loading a specific asset or updating specific data on the page. Unity is able to interact directly with the web browser (WebGL builds), so a question arises; how can we apply this to our games?

<!--more-->

Many older arcade style games contained level codes that could be used to directly reach a point within a game. Using a query string, we could load an arbitrary point in our WebGL build. Each time a new level is reached in game, the URL would update automatically with the level code. Now, a user can save this URL and return later to play that level again whenever they want. This is especially good for procedurally generated levels that can be generated with a seed. Use the level code as a seed, and you have uniquely sharable levels. When the URL is loaded, the game will load the proper level. Seems reasonable, so let's get started.


How do we interact with a web browser from Unity? You can read the [documentation](https://docs.unity3d.com/Manual/webgl-interactingwithbrowserscripting.html), or follow along with our example.


Start by creating a new javascript plugin in the Plugins directory like so `Assets/Plugins/WebGL/QueryHandler.jslib`.

<img alt="Unity Editor js lib" src="/images/tutorials/queryString/jslib.png">

You may need to do this with an external program or through your operating system. By using the extension `.jslib` this tells the Unity compiler that this is a javascript plugin and not a UnityScript.


The following two lines are the start of your javascript plugin!

```js
var QueryHandler = {};
mergeInto(LibraryManager.library, QueryHandler);
```


The first line is a declaration of a javascript object (QueryHandler) and the second a function call to Unity that passes this object as the argument.


This file is able to contain any javascript that is valid in a web browser, however we only care about functions declared in the QueryHandler object. We need to be able to get and set the query parameter. We define a function to accomplish each, expanding the QueryHandler object.


```js
var QueryHandler = {
    GetParam: function(){
        //return param from URL
    },
    SetParam: function(param){
        //set param in URL
    }
};
mergeInto(LibraryManager.library, QueryHandler);
```


It is important to note here that javascript will only receive simple numeric types (int/float/double) without conversion. Other data types will be passed as a pointer in the emscripten heap (for full details see the documentation).


Now to add the actual implementation. If you aren’t comfortable with javascript programming that’s ok, this is a basic task and shouldn’t take too much understanding.


```js
var QueryHandler = {
    GetParam: function(){
        var level = "";
        var queryString = window.location.search.substring(1);
        var params = queryString.split("&");

        for (var i=0; i<params.length; i++) {
            var param = params[i].split("=");
            if(param[0] == "level"){ level = param[1]; }
        }

        var buffer = _malloc(lengthBytesUTF8(level) + 1);
        writeStringToMemory(level, buffer);
        return buffer;
    },
    SetParam: function(param){
        window.location.search = "?level=" + Pointer_stringify(param)
    }
};
mergeInto(LibraryManager.library, QueryHandler);
```


Lets break it down. GetParam gets the query string and splits it on the separator `&` returning an array to iterate over. Inside this iteration we split on the key/value differentiator `=` to obtain the data contained inside as key value pairs.
We are looking for a key called “level”, if the key matches that then the value associated with that key is saved in the variable called level.


The next few lines are memory allocation functions defined by Unity. Simply: they are used to pass strings from javascript into our game. Technically: We allocate enough space on the emscripten heap and write our string to it, we then return this buffer.
The SetParam function is setting the query string of the current URL, which appends the given string to the end the URL. To get the actual query string we had to do a string conversion of the pointer from Unity. This function only supports setting a single query parameter, but javascript libraries exist, or you can write something custom to support multiple.


We need to be able to call these functions from Unity. The easiest way to do this is to add the functions to any MonoBehaviour, and have that MonoBehaviour attached to a GameObject in your Unity scene.


```c#
using UnityEngine;
using System.Runtime.InteropServices;


public class QueryParamsTest : MonoBehaviour
{
    [DllImport("__Internal")]
    private static extern string GetParam();

    [DllImport("__Internal")]
    private static extern void SetParam(string str);

    void Start()
    {
        string result = GetParam();
        Debug.Log("[QP] Level: " + result);

        SetParam("XYZA");
        result = GetParam();
        Debug.Log("[QP] Level After Set: " + result);
    }
}
```


Now build for WebGL and test it out!


Hopefully this has helped you and we can’t wait to see what you come up with.
