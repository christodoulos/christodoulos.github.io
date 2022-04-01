---
title: "The big picture"
date: 2022-04-01
tags: [digital twins]
---

# The big picture

A bird’s eye view of a Digital Twin implementation that incorporates modern technological
advancements could be depicted in the following figure. Clients are running the Digital Twin’s
frontend that displays objects bound to backend entities. The front-end implementation uses
“observable” constructs, adjusting displayed objects to “live” back-end queries. The backend
implementation involves a sensor cloud that constantly updates a real-time database. The
real-time database automatically pushes updates to every connected client.

<!-- prettier-ignore -->
{{< mermaid >}}
flowchart 
    client[Client]
    client <--> backend
    frontend <--> client
    realtime -.-> client
    subgraph DigitalTwin [Digital Twin]
        frontend[Frontend]
        subgraph backend [Backend]
            realtime[Realtime Database]
            subgraph SensorCloud [Sensor Cloud]
                sensors[Various Sensors <br> Existing APIs <br> Other DT<br> ...]      
            end
        end
        SensorCloud --> realtime
    end
{{< /mermaid >}}

The javascript programming language seems the reasonable way to go regarding the
development of a cross-platform frontend. There are well-established javascript frameworks
(Angular, React, Vue, etc.) that provide modern tools for any development target, i.e., for
web, mobile web, native mobile, and native desktop. Significantly, bindings are available to
stable and established javascript libraries like Mapbox, Google Maps, or ArcGIS API.

We can implement the real-time nature of the backend database by utilizing technologies
like Google’s Firebase or the change streams feature of MongoDB. Both approaches should
incorporate their front-end counterpart that implements the “observable” constructs that
adjust to the ever-changing backend entities (e.g., the Angular Firebase library or the native
MongoDB driver for Node.js and the socket IO library).
