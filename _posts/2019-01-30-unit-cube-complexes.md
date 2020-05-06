---
layout: post
title: Unit Cube Complexes
subtitle: On determining the outer shell of a UCC
comments: true
math: true
tags: research python
---

{:.abstract}
The traditional Finite Element approach discetizes a continous orthogonal domain into smaller elements of a specific shape. We consider unit cube complexes (first picture below) that may be produced by Deep Learning methods as in \ref{kallioras}

![A unit cube complex](/assets/images/ucc2stl/ucc.svg){: .center-block :}


## Unit cube ordering in 3D space

Consider an axes aligned unit cube and that the $xz$ plane represents a traditional map where the four points of the horizon are defined by the common practice. There are six primal directions, north, south, east, west, top and bottom, towards each of which every cube's face can be labeled according to the direction.

![The six primal directions in 3D space](/assets/images/ucc2stl/uccpd.svg){: .center-block :}

Each of the labeled cube faces can be represented as a counterclockwise or clockwise list of its vertices regarding the cube's interior. A counterclockwise listing is used when the interior is below, left of or behind the face and a clockwise listing is used when the interior is above, right or in front of the face (see the second figure above):

- The _north face_ is $0321$
- The _south face_ is $4567$
- The _east face_ is $6512$
- The _west face_ is $0473$
- The _top face_ is $3762$
- The _bottom face_ is $0154$

Every unit cube in 3D space has a _centroid_ whose coordinates can be calculated as a simple function of the coordinates of the cube vertices:

$$ c=(x,y,z) = \left( \frac{\sum_{i=1}^8}{8}x_i, \frac{\sum_{i=1}^8}{8}y_i, \frac{\sum_{i=1}^8}{8}z_i \right) $$

The centroid can also be realized as the vector starting from $(0,0,0)$ towards $(x,y,z)$. Given two unit cubes $C_1$ and $C_2$ in 3D space there is a well defined ordering if we consider the relative positions of the cubes' centroids: cube $C_2$ _is bigger_ than cube $C_1$, i.e. $C_2$ is located (right / on top / in front) of $C_1$, if and only if $c_2=(x_2,y_2,x_2)>c_1=(x_1,y_1,x_1)$. The same reasoning applies also when we try to locate the immediate next of the unit cube $C$ with centroid $(x,y,z)$ along each of the $x$, $y$, $z$ axes:

![Unit cube ordering](/assets/images/ucc2stl/uc-ordering.svg){: .center-block :}

- the _west_ cube is around $(x+1,y,z)$
- the _top_ cube is around $(x,y+1,z)$
- the _south_ cube is around $(x,y,z+1)$
- similarly for _east_, _bottom_ and _north_

## Python Implementation

We are going to describe in detail the implementation of the above ideas in the _Python_ programming language.

## A Python class for 3D points

A Python class for 3D points that supports various methods and implements the usual lexicographic ordering is the following:

```python
class Point(object):
"A class for 3D points"

    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    @classmethod
    def from_point(cls, point):
        "Initializes a 3D point from another point"
        return cls(point.x, point.y, point.z)

    @classmethod
    def from_tuple(cls, tup):
        "Initializes a 3D point from a tuple of 3 values"
        return cls(tup[0], tup[1], tup[2])

    @property
    def coordinates(self):
        "Returns the coordinates of the 3D point"
        return self.x, self.y, self.z

    def __repr__(self):
        return 'Point({0},{1},{2})'.format(self.x, self.y, self.z)

    def __hash__(self):
        return hash((self.x, self.y, self.z))

    def __eq__(self, other):
        if not other:
            return False
        return (self.x, self.y, self.z) == (other.x, other.y, other.z)

    def __ne__(self, other):
        if not other:
            return True
        return (self.x, self.y, self.z) != (other.x, other.y, other.z)

    def __lt__(self, other):
        return (self.x, self.y, self.z) < (other.x, other.y, other.z)

    def __gt__(self, other):
        return (self.x, self.y, self.z) > (other.x, other.y, other.z)

    def __le__(self, other):
        return (self.x, self.y, self.z) <= (other.x, other.y, other.z)

    def __ge__(self, other):
        return (self.x, self.y, self.z) >= (other.x, other.y, other.z)

    def __getitem__(self, index):
        return (self.x, self.y, self.z)[index]

    def __setitem__(self, index, value):
        temp = [self.x, self.y, self.z]
        temp[index] = value
        self.x, self.y, self.z = temp

    def __iter__(self):
        yield self.x
        yield self.y
        yield self.z

    def __sub__(self, other):
        "Subtracts two points giving the vector that translates other to self"
        return Vector(other.x - self.x, other.y - self.y, other.z - self.z)

    def __add__(self, vector):
        "Translates self to another points using 'vector' vector"
        return Point(self.x + vector.x, self.y + vector.y, self.z + vector.z)
```

Παράδειγμα χρήσης των παραπάνω κλάσεων:

```python
>>> from primitives import *
>>> a, b = Point(1, 2, 3), Point(4, 5, 6)
>>> a-b
Vector(3,3,3)
>>> b-a
Vector(-3,-3,-3)
>>> Point(1, 2, 3) + Vector(3, 3, 3)
Point(4,5,6)
```
