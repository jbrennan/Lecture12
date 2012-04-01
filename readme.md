Assignment 3
============

This is the iPhone project.

Open the Lecture12.xcodeproj file, that's where you'll find all the project.

In the Files navigator, you'll see all the files in the project. They're mostly in the order in which they appear in the application. Also, there's a group at the bottom called `Unused in Project`. As you might be able to guess, those were not used in the project.

Files
-----

`JBAppDelegate` has the main app delegate for the project. Notable stuff here is the **Backgrounding** code, where I send the Server a logout message when the app enters the background.

`JBServicesBrowserTableViewController` is the first interface shown to the user, which will display any found Bonjour services, or let the user start 1 if they so desire. This class works in tandem with `JBServicesBrowser`, which is found in the `Network layer` folder.

`JBIMRoomsTableViewController` is the class which shows all the users logged in to the chosen server (chosen from the previous screen). This class will also try to load a picture for each user, which comes from the `JBImageCache` class.

`Network Layer` is a folder that has some model classes. The `JBServicesBrowser` class wraps around the Bonjour stuff. It also optionally owns 1 instance of my Server class. `JBIMServer` owns a listening socket and a bunch of client sockets. When a message comes off one of the listening sockets, I *react* by executing a Block object to handle the message. This is my implementation of the Reactor pattern, only I can do it all inline without needing separate classes for each message type.

`JBIMClient` also owns a socket and it's used to talk to the server. When a message is sent, I also pass along a Block object for a callback handler, which gets executed when the server responds to the message (or is executed as soon as the message is sent, in the case of the TEXT messages).

`JBMessage` is the wrapper around the JSON objects which get sent over the sockets. `GCDAsyncSocket` is from the AsyncSocket library Tony said we could use for this project.

`Chat Stuff` are mostly model classes which take care of representing a Chat message, a chat room (i.e., between 2 users) and actually displaying all the messages in a given room.

`JBImageCache` keeps cached images in a dictionary, and if there's a cache miss, then it asynchronously loads the images off the internet using Grand Central Dispatch. It pulls the images off an identicon service provided by Stack Overflow, which will generate a unique image for each username thrown at it. It caches the returned images in a dictionary and executes a Block object callback back on the main queue.

The rest of the classes are mostly not used, or just used for building up the UI or supporting the Server.