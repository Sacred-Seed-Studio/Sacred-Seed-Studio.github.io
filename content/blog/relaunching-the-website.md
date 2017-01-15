+++
date = "2017-01-15T12:28:58-04:00"
title = "Relaunching the Website"
categories = ["website"]
author = "Joel Kuntz"
draft = false

+++

Over the past ~month the website has seen some enhancements, but today the biggest of all. We switched from [Jekyll](http://jekyllrb.com/) to [Hugo](http://gohugo.io/) as our static site generator.

While Jekyll may be more mature it turned out to be difficult to tune it to exactly how we wanted. Our Tutorials are now separate from our blog. This was a big struggle point with Jekyll and it seems Hugo was built with that in mind. Some other improvements: We added a gallery, improved our games page, created a new logo, and added https support. The site is much easier to maintain now with continuous deployment from CircleCI. This went quite well and makes the website ready for an awesome 2017! We definitely recommend Hugo and the switch from Jekyll wasn't too bad.

If you are interested in how this website was built, please checkout it's [repository here](https://github.com/Sacred-Seed-Studio/Sacred-Seed-Studio.github.io). I have tagged the final state of the Jekyll site and the initial working state of the hugo site under the [Releases page](https://github.com/Sacred-Seed-Studio/Sacred-Seed-Studio.github.io/releases). If you have any questions feel free to let us know!