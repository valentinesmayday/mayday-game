# How to Implement a Visual Novel with this Program

## Story Node Concept

The novel is composed of story nodes, or just "nodes" for short.
A node contains 0, 1 or 2 lines being spoken by a character
whose portrait is shown. It also contains 1 or 2 responses that
the user needs to select.  Each response is associated with another
story node; when a response is selected, the system transitions
to the associated story node. If there is no story node
associated with a response, then choosing the response ends the story.
Story nodes also specify music to be played.

## Basic Story Node Construction

Each node is represented by a Lua script stored under the
following folder:

    working/nodes/

The following node is the starting point of the novel.

    working/nodes/start.lua

The node files are Lua scripts.  The system looks for the following
variable assignments in each node.

p = character portrait to display (optional)
m = music to start if not already playing
a1 = line 1 spoken by character (optional)
a2 = line 1 spoken by character (optional)
b1 = choice 1 text for user (required)
b2 = choice 2 text for user (optional)
c1 = story node to go to if user chooses 1 (optional; omit to end story on choice 1)
c2 = story node to go to if user chooses 2 (optional; omit to end story on choice 2)

## Advanced Story Node Construction

In addition to the variables listed above, you can include arbitrary script to run
when the systems goes to the story node.  We need to implement and expose additional
functionality to the nodes in through the story/screen module. In particular,
we need to save a history of significant events such as choices made by the user
and any random outcomes, so that story nodes can alter their behaviors accordingly.

This is under construction.

## Reload Story Node

Press the 'R' key to reload a story node.
This let's you fine-tune a story node without having to restart
the game.


