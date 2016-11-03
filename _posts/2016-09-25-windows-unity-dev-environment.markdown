---
layout: post
title:  "Setting up a Unity dev environment on Windows"
date:   2016-09-25
categories: tutorial unity git windows
class: blog
author: "Joel Kuntz"
---
Whether you are just starting with Unity, reinstalling your operating system, or helping a friend; we all have to setup development environments. I frequently do this and there are several essential things needed for a well rounded environment. I hope to share my insights so that you can create your own environment and start making games in Unity right now.
Programs to install:  

* [Unity](https://unity3d.com/) (the installer includes Visual Studio, the IDE I use)
* git (see below)

### Step 1: Install Unity and IDE/Text Editor
The installer for Unity now has Visual Studio (Community version), where it used to include MonoDevelop. VS is a heavy IDE to start up, but it is very powerful for C#, which is the language we recommend using over Javascript. If you don't want something as heavy as VS, you can also download [Sublime Text 3](https://www.sublimetext.com/3), [Atom](https://atom.io/), or [VS Code](https://code.visualstudio.com/) and use those instead. To change the IDE/text editor connected to Unity, inside a project, go to `Edit > Preferences... > External Tools` and browse to find your editor of choice.

<img alt="Unity Editor Git Settings" src="{{site.base-url}}/assets/images/blog/unitydevenv/ChangeTextEditor.png">

### Step 2: Install Git
Windows 10 recently added the Windows Subsystem for Linux which allows you to run Ubuntu Bash. This is my favorite way to use git on windows. You can [install WSL](http://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/) and run `sudo apt install git`, or alternatively get [native applications](https://git-scm.com/downloads) of git, including some GUI applications like [Sourcetree](https://www.sourcetreeapp.com/) or [GitHub Desktop](https://desktop.github.com/). 

<p class="note">If you aren't familiar with version control, you should be. It allows you to backup your project, tag points in time that can be referenced later, and easily work with a team or on an open source project. I can't overstate this! Please trust me when I say it will save you from frustration in the future. <a href="https://git-scm.com/book/en/v2">Learn git</a> and go backup your projects now. Both <a href="https://github.com/">github</a> and <a href="https://bitbucket.org/">bitbucket</a> offer good free options.</p>

<p class="note">If you're a student, go get the <a href="https://education.github.com/pack">GitHub Student Developer Pack.</a></p>

### Step 3: Creating a Project and Changing Project Settings
Open Unity and log in to your account to be able to create a new project. You can choose where to save your project and whether or not it should be 2D or 3D. If you create a project and it's not the dimension you want, you can change between 2D and 3D by going to `Edit > Project Settings > Editor`. Some versions of Unity contain a bug that creates a project and it doesn't use the dimension you asked for, if that happens, just change your settings and then create a new scene to see the correct camera style.

Each time you create a new Unity project, you'll need to change some settings to work with version control. I'm assuming this methodology will work for more than just git, but that's what we will be using. Inside your unity project, go to `Edit > Project Settings > Editor` and change `Version Control` to `Visible Meta Files`. You will also need to change `Asset Serialization` to `Force Text`. Most version controls work in deltas or diffs, and it's a lot easier for them to work in text than binary.

<img alt="Unity Editor Git Settings" src="{{site.base-url}}/assets/images/blog/unitydevenv/UnityEditorSettingsForGit.png">

### Step 4: Creating a Repository

#### i: Setup
You will now need to setup your repository, repo for short. You can make a repository in two ways, whether or not you have or haven't started your project yet. 

The first way is through bash (or your command line):
{% highlight bash %}
mkdir my-new-project
cd my-new-project
git init
{% endhighlight %}

The second way is through an online interface: github(shown)
<img alt="Unity Editor Git Settings" src="{{site.base-url}}/assets/images/blog/unitydevenv/GithubUnityProject.png">
There are some important settings when creating a repo on Github:  

*  `Public/Private toggle` If you have paid/copyrighted assets you should either not commit the assets to the repository or have a private repository. 
*  `Readme & license` If you are creating something open source, a readme and proper license are important and informative. MIT is a very permissive license for open source.

#### ii: GitIgnore   
 `.gitignore` Is a special file that tells git what we don't want committed to the repository. This is used for binaries, assets, and Unity Editor/IDE created files that only slow things down and cause headaches for us and others accessing our project. [github hosts the unity one](https://github.com/github/gitignore/blob/master/Unity.gitignore) like is selected above.  

 If you went the command line route, there will be a hidden file named `.gitignore` in the root of your repository. You can open it and view it in a text editor. _It should be the very first thing you commit_. The `.gitignore` below will assume you have your Unity Project at the root of your repository.  

 <p class="note">If you want your Unity Project to be nested or to have multiple projects in this repo then simply remove the leading /</p>

{% highlight bash %}
/[Ll]ibrary/
/[Tt]emp/
/[Oo]bj/
/[Bb]uild/
/[Bb]uilds/
/Assets/AssetStoreTools*
# Autogenerated VS/MD/Consulo solution and project files
ExportedObj/
.consulo/
*.csproj
*.unityproj
*.sln
*.suo
*.tmp
*.user
*.userprefs
*.pidb
*.booproj
*.svd
# Unity3D generated meta files
*.pidb.meta
# Unity3D Generated File On Crash Reports
sysinfo.txt
# Builds
*.apk
*.unitypackage
{% endhighlight %}
  

#### iii: Committing and Pushing
Move your Unity project into your repository folder. You'll need to close Unity before doing this. Now that we have our gitignore it will be safe to move it all over as we only will add `Assets/` and `Project Settings/` to commit as the rest is autogenerated by Unity and our IDE. Unity project structure usually looks like this:
<p class="note"> Sometimes when you're moving a project, a Unity Lock file won't want to move and will cause trouble, skipping that file is ok.</p>

{% highlight bash %}
my-new-project/
├── Assets
├── Library
├── ProjectSettings
└── Temp
{% endhighlight %}

The following commands will add the files in your new project to be committed, review the commit, make the commit, then push to your remote (Github etc). If this is confusing, again, [Learn git](https://git-scm.com/book/en/v2). 
{% highlight bash %}
git add Assets/ ProjectSettings/
git status #Review what we have staged before committing
git commit -m 'Initial unity project commit.'
git push origin master # If you are setup to a remote like github/bitbucket
{% endhighlight %}

### Step 5: Find, Create and Edit Assets
Now that you have a project and a repo, you'll need some assets for your game, and ways of dealing with them.

#### Finding Assets:
* [Open Game Art](http://opengameart.org/)
* [Kenney](http://kenney.nl/assets) offers free assets on Open Game Art, but he does amazing work and it's definitely worth it to support him and buy his art
* [Incompetech](https://incompetech.com/)

#### Creating and Editing Assets:
* [Audacity](http://www.audacityteam.org/)
* [Blender](https://www.blender.org/)  
* [Paint.NET](http://www.getpaint.net/download.html) or [GIMP](https://www.gimp.org/)
* [Tiled](http://www.mapeditor.org/)

#### Cool People and Repositories:
* [Keijiro Takahashi](https://github.com/keijiro)
* [Prime 31](https://github.com/prime31)
* Unity [Bitbucket](https://bitbucket.org/Unity-Technologies/) . [GitHub](https://github.com/Unity-Technologies)
* [Awesome Unity](https://github.com/RyanNielson/awesome-unity)  

You are now ready to begin (or continue) your game development journey. A few bits of closing advice:

* Commit [atomically](https://en.wikipedia.org/wiki/Atomic_commit#Atomic_commit_convention) and commit often
* Write meaningful [commit messages](http://chris.beams.io/posts/git-commit/)
* ALWAYS push new commits to your remote
* Use [git tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) for milestones 
* Have a [well organized](http://blog.theknightsofunity.com/7-ways-keep-unity-project-organized/) unity project
* If you are working solo it is generally fine to work off the master branch. If you are working on a team, learn the [power of branches](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell) and decide on a workflow([1](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows), [2](https://git-scm.com/book/en/v2/Distributed-Git-Distributed-Workflows#_distributed_git), [3](https://www.atlassian.com/git/tutorials/comparing-workflows/), [4](https://guides.github.com/introduction/flow/)) with your team to avoid conflicts and wasted time.


  
Good luck explorers!