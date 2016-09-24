---
layout: post
title:  "Global Game Jam 2016 Postmortem"
date:   2016-03-05
categories: gamejam
class: blog
---
To introduce us and finally launch our website we decided what better way then to do a postmortem of Global Game Jam 2016!

For our second GGJ together we decided to focus on a smaller game, which allowed us to actually complete it this year! For the theme: Ritual, we created a game where you are in charge of collecting holy water for your village each day. To complete the ritual, you must pray to different gods each day to grant access to the river water. You can read more about it 
[here]({{site.base-url}}/games/ritual-river).

<img alt="Ideas are flowing" src="{{site.base-url}}/assets/images/blog/ggj2016/start.jpg">

<img alt="Ritual River Spritesheet" src="{{site.base-url}}/assets/images/blog/ggj2016/title.png">

This year's jam was again hosted at Volta, this time at their new location (which was awesome!). A huge thank you to everyone involved setting it up, as it was a great place to jam and meet new people.

Our goal in this first post is to talk about our experiences at the Jam and to give perspective on our process and what we learned over that weekend.

## Joel
A snowstorm didn't stop us or the ~60 people at Volta for this year's game jam. It was awesome meeting so many passionate people all there for the same goal: to have fun and make a game. This years jam went surprisingly smooth and we encountered few issues. The first issue I encountered was using GitHub's Unity gitignore. I submitted a pull request to fix this issue months prior, but another PR was merged that undid my changes. It was frustrating and it led me having to redo the title scene three times. By the end of it I flew threw the remaking and learned a very important lesson: know how your version control is setup to avoid any unintended occurrences.
Our workflow usually goes as follows:

1. Create a new project on GitHub
2. Setup the project with a README/LICENSE and .gitignore
3. Clone the project and create a new Unity project in there

Our reasoning you ask? Sometimes we have multiple projects in one repository and this workflow works well for that. Unity doesn't allow you to create a new project in a non empty folder. There are other workflows sure, but we are used to this one and quite like it. The solution moving forward is we now have our own [repository](https://github.com/Sacred-Seed-Studio/Unity-Gitignore) with a gitignore that follows our workflow. 

Overall I learned a lot this weekend and remembered why I love programming in Unity in the first place. I look forward to finishing school and having more time to work on more projects and game jams!

<img alt="Ritual River Spritesheet" src="{{site.base-url}}/assets/images/blog/ggj2016/game.png">

## Sarah

For this game jam, I admit, we didn't do a very good job of planning. We did have one large white board which housed most of our ideas for the entire weekend. Despite not having a single 'formal' document, we were able to create an entire (mostly fun) game. :)

Things started off pretty smoothly, and like most games, the first step was to get basic shapes moving around the screen. Then I added the main character animations and backgrounds and a game was born. The logic behind the game was fairly simple, each day began and the hero was in his village, and he would start down towards the river. A set of pedestals were scattered along the path to the river, and each day, before leaving the village, the hero would see which 3 gods he had to pray too. By praying at the matching pedestals, the gate to the river would open, and water would be available! Half of the the time spent here was working on assets, the character and gate animations and what not.

The only challenge left after implementing all of the above, was making some monkeys to add a challenge. In the end, when the game jam was over, the monkeys were sort of menacing (after a post game jam update, they were much MORE menacing, I promise!).

We ran into a weird copy/paste bug during the last hour of the game jam, while I was trying to add our audio in before the deadline. The bug was random and we weren't able to figure it out until later in the night. But Ritual River turned out pretty great anyways and I'm satisfied with the weekend!

## Kevin

I had a great time at this year’s Global Game Jam. It felt great to put all all of my focus into one thing for a whole weekend. I ended up learning a lot, and I always do during hackathons.

Shown below is the sprite sheet I made as the hero in our game Ritual River. Seeing as we only had 48 hours to fully complete our project, we decided it was a good idea to keep it simple. It turns out all you need to have a functioning walking animation is 20 sprites; many of which are copies. The 4  left most sprites are the idle sprites, and each other row is a direction of the walking animation. Notice how when his leg is behind the other I’ve made it slightly darker to help create the illusion of walking.

<img alt="Ritual River Spritesheet" src="{{site.base-url}}/assets/images/blog/ggj2016/sprite.png">

I’m looking forward to our future projects so I can learn more about the basics of sprite design and making image assets for games!
