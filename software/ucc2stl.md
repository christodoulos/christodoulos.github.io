---
layout: default
title: ucc2stl
math: true
code: true
cclicense: true
permalink: software/ucc2stl
---

# ucc2stl

**ucc2stl** is a Pyhton package that calculates the outer shell of standard fea
models of unit cubes represented by nodes, connectivity and density
representation. The output is in _STL_ format.

**ucc2stl** is a joint work of Christodoulos Fragkoudakis and Markos Karampatsis.

## Unit Cube Complexes

The traditional Finite Element approach discetizes a continuous orthogonal
domain into smaller elements of a specific shape. We consider unit cube
complexes (first picture below) that may be produced by special models of
finite element analysis methods.

![A unit cube complex](/assets/img/ucc2stl/ucc.svg){: .center-block :}

## Unit cube ordering in 3D space

Consider an axes aligned unit cube and that the $xz$ plane represents
a traditional map where the four points of the horizon are defined by the
common practice. There are six primal directions, north, south, east, west, top
and bottom, towards each of which every cube's face can be labeled according to
the direction.

![The six primal directions in 3D space](/assets/img/ucc2stl/uccpd.svg){: .center-block :}

Each of the labeled cube faces can be represented as a counterclockwise or
clockwise list of its vertices regarding the cube's interior.
A counterclockwise listing is used when the interior is below, left of or
behind the face and a clockwise listing is used when the interior is above,
right or in front of the face (see the second figure above):

- The _north face_ is $0321$
- The _south face_ is $4567$
- The _east face_ is $6512$
- The _west face_ is $0473$
- The _top face_ is $3762$
- The _bottom face_ is $0154$

Every unit cube in 3D space has a _centroid_ whose coordinates can be
calculated as a simple function of the coordinates of the cube vertices:

$$
c=(x,y,z) = \left( \frac{\sum_{i=1}^8}{8}x_i, \frac{\sum_{i=1}^8}{8}y_i,
\frac{\sum_{i=1}^8}{8}z_i \right)
$$

The centroid can also be realized as the vector starting from $(0,0,0)$ towards
$(x,y,z)$. Given two unit cubes $C_1$ and $C_2$ in 3D space there is a well
defined ordering if we consider the relative positions of the cubes' centroids:
cube $C_2$ _is bigger_ than cube $C_1$, i.e. $C_2$ is located (right / on top
/ in front) of $C_1$, if and only if $c_2=(x_2,y_2,x_2)>c_1=(x_1,y_1,x_1)$. The
same reasoning applies also when we try to locate the immediate next of the
unit cube $C$ with centroid $(x,y,z)$ along each of the $x$, $y$, $z$ axes:

![Unit cube ordering](/assets/img/ucc2stl/uc-ordering.svg){: .center-block :}

- the _west_ cube is around $(x+1,y,z)$
- the _top_ cube is around $(x,y+1,z)$
- the _south_ cube is around $(x,y,z+1)$
- similarly for _east_, _bottom_ and _north_

## Python Implementation

We are going to describe in detail the implementation of the above ideas in the
_Python_ programming language.

## A Python class for 3D points

A Python class for 3D points that supports various methods and implements the
usual lexicographic ordering is the following:

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
      "Subtracts two points giving the vector that anslates other to self"
      return Vector(other.x - self.x, other.y - self.y, other.z - self.z)

  def __add__(self, vector):
      "Translates self to another points using 'vector' ctor"
      return Point(self.x + vector.x, self.y + vector.y, self.z + vector.z)
```

## A Python class for 3D Vectors

A Python class for 3D Vectors that inherits from `Point` and implements the
basic property of magnitude (no need for a square root operation here) and the
cross product with another instance of the vector class is the following:

```python
class Vector(Point):

    "A class for 3D Vectors"

    def __init__(self, *args):
        if not args:
            x, y, z = 0, 0, 0
        elif len(args) == 1:
            if args[0].__class__ is Point:
                x, y, z = args[0].x, args[0].y, args[0].z
            else:
                x, y, z = args[0], 0, 0
        elif len(args) == 2:
            x, y, z = args[0], args[1], 0
        else:
            x, y, z = args[0], args[1], args[2]
        self.coords = [x, y, z]
        super(Vector, self).__init__(x, y, z)

    def __repr__(self):
        return "Vector({1}{0}{2}{0}{3})".format(',', self.x, self.y, self.z)

    @property
    def magnitude2(self):
        "Returns the squared magnitude of the vector."
        return self.x**2 + self.y**2 + self.z**2

    def cross(self, vector):
        "Returns the cross product of self and vector"
        return Vector(
            (self.y * vector.z - self.z * vector.y),
            (self.z * vector.x - self.x * vector.z),
            (self.x * vector.y - self.y * vector.x))
```

Testing the above classes in the Python interpreter:

```python
>>> from ucc2stl import Point, Vector
>>> x = Point(1,2,3)
>>> y = Point(4,5,6)
>>> x-y
Vector(3,3,3)
>>> z = Vector(3,3,3)
>>> x+z
Point(4,5,6)
```

## A Python class for unit cubes

We start with the implementation of a unit cube's face:

```python
class Face(object):

    "A general representation of a complex's face"

    def __init__(self, vertices):
        "self.vertices is an iterable of Point"
        self.vertices = vertices

    def __repr__(self):
        _repr = "\nFace\n"
        for vertex in self.vertices:
            _repr += "\t%s\n" % vertex
        return _repr

    def normal(self):
        "A vector perpendicular to the face"
        v = self.vertices
        v1 = v[0] - v[1]
        v2 = v[0] - v[2]
        return v1.cross(v2)
```

A cuboid is a collection of six faces, namely the _north_, _south_, _east_,
_west_, _top_ and _bottom_ face (see the relevant picture above). We implement
the face dictionary using the above definitions. The face representation is
a counterclockwise listing of its vertices when the interior of the cuboid is
below, left or behind the face. Otherwise the representation is a clockwise
listing of vertices. The _centroid_ of the cuboid is the weighted average of
the cuboid's vertices.

```python
class Face(object):

    "A class for a cuboid's face"

    def __init__(self, vertices):
        "self.vertices is an iterable of Point"
        self.vertices = vertices

    def __repr__(self):
        _repr = "\nFace\n"
        for vertex in self.vertices:
            _repr += "\t%s\n" % vertex
        return _repr

    def normal(self):
        "docstring"
        v = self.vertices
        v1 = v[0] - v[1]
        v2 = v[0] - v[2]
        return v1.cross(v2)


class Cuboid(object):

    "A class for cuboids"

    def __init__(self, vertices):
        self.vertices = sorted(vertices)
        v = self.vertices
        self.facedict = {
            "north": Face([v[0], v[2], v[6], v[4]]),
            "south": Face([v[1], v[5], v[7], v[3]]),
            "east": Face([v[5], v[4], v[6], v[7]]),
            "west": Face([v[0], v[1], v[3], v[2]]),
            "top": Face([v[6], v[2], v[3], v[7]]),
            "bottom": Face([v[0], v[4], v[5], v[1]]),
        }

    def __repr__(self):
        _repr = "\nCuboid:\n--------\nVertices\n--------\n"
        for vertex in self.vertices:
            _repr += "\t%s\n" % vertex
        _repr += "-----\nFaces\n-----\n"
        for orientation, face in self.faces:
            _repr += "{0}: {1}".format(orientation, face)
        return _repr

    def __eq__(self, other):
        return self.centroid == other.centroid

    def __ne__(self, other):
        return self.centroid != other.centroid

    def __lt__(self, other):
        return self.centroid < other.centroid

    def __qt__(self, other):
        return self.centroid > other.centroid

    def __le__(self, other):
        return self.centroid <= other.centroid

    def __ge__(self, other):
        return self.centroid >= other.centroid

    @property
    def faces(self):
        "docstring"
        for orientation, face in self.facedict.items():
            yield orientation, face

    @property
    def centroid(self):
        "Returns the centroid of the cuboid"
        x, y, z = 0.0, 0.0, 0.0
        for vertex in self.vertices:
            x += vertex.x
            y += vertex.y
            z += vertex.z
        return Point(x / 8.0, y / 8.0, z / 8.0)
```

Using the above classes in the Python interpreter:

```python
>>> from ucc2stl.cuboids import Cuboid
>>> from ucc2stl import Point
>>> x1 = Point(0,0,0)
>>> x2 = Point(1,0,0)
>>> x3 = Point(1,1,0)
>>> x4 = Point(0,1,0)
>>> x5 = Point(0,0,1)
>>> x6 = Point(1,0,1)
>>> x7 = Point(1,1,1)
>>> x8 = Point(0,1,1)
>>> c = Cuboid([x1,x2,x3,x4,x5,x6,x7,x8])
>>> c

Cuboid:
    --------
    Vertices
    --------
            Point(0,0,0)
            Point(0,0,1)
            Point(0,1,0)
            Point(0,1,1)
            Point(1,0,0)
            Point(1,0,1)
            Point(1,1,0)
            Point(1,1,1)
    -----
    Faces
    -----
        north:
            Face
                    Point(0,0,0)
                    Point(0,1,0)
                    Point(1,1,0)
                    Point(1,0,0)
        south:
            Face
                    Point(0,0,1)
                    Point(1,0,1)
                    Point(1,1,1)
                    Point(0,1,1)
        east:
            Face
                    Point(1,0,1)
                    Point(1,0,0)
                    Point(1,1,0)
                    Point(1,1,1)
        west:
            Face
                    Point(0,0,0)
                    Point(0,0,1)
                    Point(0,1,1)
                    Point(0,1,0)
        top:
            Face
                    Point(1,1,0)
                    Point(0,1,0)
                    Point(0,1,1)
                    Point(1,1,1)
        bottom:
            Face
                    Point(0,0,0)
                    Point(1,0,0)
                    Point(1,0,1)
                    Point(0,0,1)
```
