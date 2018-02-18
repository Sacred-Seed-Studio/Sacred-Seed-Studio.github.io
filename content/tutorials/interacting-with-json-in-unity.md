+++
date = "2017-06-10T13:27:39-03:00"
updated = "2018-02-11T00:00:00+00:00"
title = "Interacting with JSON in Unity"
draft = false
categories = ["unity","json","tutorial"]
author = "Joel Kuntz"
image = "/images/tutorials/interacting-with-json-in-unity/interacting-with-json-in-unity-cover.png"

+++

Oftentimes we find ourselves working with JSON data. Whether it's communicating with a web server or importing and exporting data. Before in Unity the solutions were you had to write your own parser/serializer, or get a third party plugin. Semi-recently the JsonUtility class was introduced in the UnityEngine namespace. It won't solve all of your problems, but it is a great built in tool. This tutorial builds a simple example to demonstrate handling JSON.
<!--more-->

The focus is on the data found on https://jsonplaceholder.typicode.com this allows us to use a live server and have a real world use case. If this server ever goes down you can use the [backup data](https://github.com/Sacred-Seed-Studio/tutorials/tree/master/interacting-with-json-in-unity/Assets/Data). This is by no means a tutorial about web request best practices in Unity, but does show a real world use case for JSON.


<p class="note">This is a git friendly tutorial. You can follow the steps by clicking the commit link in the header. You can see the <a href="https://github.com/Sacred-Seed-Studio/tutorials/tree/master/interacting-with-json-in-unity">completed project here.</a> Darker screenshots are in Play mode.</p>
  
  
### Setup

#### Unity [a545ebe](https://github.com/Sacred-Seed-Studio/tutorials/commit/a545ebe0aa3c840e5f1df5253eaa0eae93187d6c)

Setup a new unity project or open an existing one.

#### Data Structures [c1e22b3](https://github.com/Sacred-Seed-Studio/tutorials/commit/c1e22b33ae55feea013457a572f4264bcc72e76c)

To start we will create two data structures to match a Post and User. You can check out their json response at the urls below:  
https://jsonplaceholder.typicode.com/users/1  
https://jsonplaceholder.typicode.com/posts/1

Structs are used for simplicity, but this could be a class with a constructor and ToString override.

```c#
// Assets/DataStructures/Post.cs
[System.Serializable]
public struct Post
{
    public int userId;
    public int id;
    public string title;
    public string body;
}

// Assets/DataStructures/User.cs
[System.Serializable]
public struct GeoCoords
{
    public float lat;
    public float lng;
}

[System.Serializable]
public struct Address
{
    public string street;
    public string suite;
    public string city;
    public string zipcode;
    public GeoCoords geo;
}

[System.Serializable]
public struct Company
{
    public string name;
    public string catchPhrase;
    public string bs;
}

[System.Serializable]
public class User 
{
    public int id;
    public string name;
    public string email;
    public Address address;
    public string phone;
    public string website;
    public Company company;
}
```

#### API [f7a01a2](https://github.com/Sacred-Seed-Studio/tutorials/commit/f7a01a275a5666744b5754b525bed8a3634190a4)

Next, create an API class. Used to store the base url of the server; this will help prevent typos and other weird bugs in the code.

```c#
// Assets/API/API.cs
public class API 
{
    public static string baseURL = "https://jsonplaceholder.typicode.com";
}
```

### Simple Example [019ba2f](https://github.com/Sacred-Seed-Studio/tutorials/commit/019ba2fdb8a289dc88bf678110d63ee452da241f)

For a simple example, make a new C# MonoBehaviour and attach it to an empty game object.
This script will make a GET request to fetch a post and a user. These requests can later be customized.  

The following are used:

- [WWW](https://docs.unity3d.com/ScriptReference/WWW.html)  
- [JsonUtility](https://docs.unity3d.com/ScriptReference/JsonUtility.html)  
- [Coroutines](https://docs.unity3d.com/Manual/Coroutines.html)  

```c#
// Assets/SimpleExample/SimpleExample.cs
using System.Collections;
using UnityEngine;

public class SimpleExample : MonoBehaviour
{
    public User user;
    public Post post;

    void Start()
    {
        StartCoroutine(LoadPost());
        StartCoroutine(LoadUser());
    }

    IEnumerator LoadPost()
    {
        WWW www = new WWW(API.baseURL + "/posts/1");
        yield return www;
        post = JsonUtility.FromJson<Post>(www.text);
        Debug.Log("Post: " + www.text);
    }

    IEnumerator LoadUser()
    {
        WWW www = new WWW(API.baseURL + "/users/1");
        yield return www;
        user = JsonUtility.FromJson<User>(www.text);
        Debug.Log("User: " + www.text);
    }
}
```

<img alt="Simple Example Unity Screenshot" src="/images/tutorials/interacting-with-json-in-unity/SimpleExample.png">

Start both example `Coroutines` in Unity's Start method and wach the new data appear in the inspector upon the web request completion. Pretty neat, and refreshingly simple. You could use `JsonUtility` synchronously with any string in place of www.text as well.

### Handling Arrays [44a5c7e](https://github.com/Sacred-Seed-Studio/tutorials/commit/44a5c7efd617c835f2d07c5b233132c4d43b79b2)

In this second part we will deal with JSON arrays. The astute Googler will have realized that `JsonUtility` doesn't support top level json arrays. However this can be worked around. Create a new class `JsonHelper` which will provide a static generic function that returns an array. This wraps the json array in a new private generic object `JsonArrayWrapper`. This is based off of [a post on the unity forums](https://forum.unity3d.com/threads/how-to-load-an-array-with-jsonutility.375735/#post-2585129).

<img alt="Handling Arrays Unity Screenshot" src="/images/tutorials/interacting-with-json-in-unity/HandlingArrays.png">

```c#
// Assets/HandlingArrays/JsonHelper.cs
using UnityEngine;

public class JsonHelper
{
    public static T[] getJsonArray<T>(string json)
    {
        string newJson = "{ \"array\": " + json + "}";
        JSONArrayWrapper<T> wrapper = JsonUtility.FromJson<JSONArrayWrapper<T>>(newJson);
        return wrapper.array;
    }

    [System.Serializable]
    private class JSONArrayWrapper<T>
    {
        public T[] array;
    }
}
```

Actual usage is quite similar to JsonUtility:

```c#
// Assets/HandlingArrays/HandlingArrays.cs
using UnityEngine;
using System.Collections;

public class HandlingArrays : MonoBehaviour
{
    public User[] users;

    void Start()
    {
        StartCoroutine(LoadUsers());
    }

    IEnumerator LoadUsers()
    {
        WWW www = new WWW(API.baseURL + "/users");
        yield return www;
        users = JsonHelper.getJsonArray<User>(www.text);
        Debug.Log("Users: " + www.text);
    }
}
```

### Exporting Data [e98b737](https://github.com/Sacred-Seed-Studio/tutorials/commit/e98b737b053ec4a16ee61cd4eee97d87359adab0)
Finally, to showcase how to turn raw data into JSON. We will make a POST request to the server simulating creation of a post. This part will vary depending on the format your server expects. Next send a request to https://jsonplaceholder.typicode.com/posts with a byte array containing the JSON version of our struct.  

Let the server know we are sending it JSON via the Content-Type header with the json mime type. When the request finishes, the id in the inspector changes.

```c#
// Assets/ExportingData/ExportingData.cs
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;

public class ExportingData : MonoBehaviour
{
    public Post post;

    void Start()
    {
        StartCoroutine(CreatePost());
    }

    IEnumerator CreatePost()
    {
        Dictionary<string, string> headers = new Dictionary<string, string>();
        headers.Add("Content-Type", "application/json");

        byte[] postData = Encoding.ASCII.GetBytes(JsonUtility.ToJson(post));

        WWW www = new WWW(API.baseURL + "/posts", postData, headers);

        yield return www;

        Debug.Log("Created a Post: " + www.text);
        post = JsonUtility.FromJson<Post>(www.text);
    }
}
```

<img alt="Exporting Data Unity Screenshot" src="/images/tutorials/interacting-with-json-in-unity/ExportingData.png">

### Bonus: Tests [45d9558](https://github.com/Sacred-Seed-Studio/tutorials/commit/45d9558c4d7c4ca9339550172908e245d02c1a68)
Its always good practice to write tests for your code. As we added our own custom JsonHelper we should write tests for it. This tutorial is about interacting with JSON so we won't get into the specifics here. However, you can peruse the commit above and check out the [Unity Documentation](https://docs.unity3d.com/Manual/testing-editortestsrunner.html), Happy coding!
