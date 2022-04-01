---
title: "On Storing Data Models"
date: 2022-04-01
tags: [digital twins, mongodb, firebase]
---

# Without a Realtime Database

Most Digital Twin projects require communication between several endpoints. These
endpoints can be anything from devices and services to applications, and eventually, data
needs to be stored somewhere for further processing and analysis.

So let’s say you want to build a Digital Twin where a device will measure temperature and
humidity values from sensors and send them to a database service to store them. Then you
want to have a web application that will fetch these values and display them in a dashboard.
The easy and lightweight way is to set up an MQTT (Message Queuing Telemetry Transport)
broker that will act as a hub and reroute all incoming messages published from the device to
all subscribed clients like the web application in this case.

Let's say that an app will do both things: display data coming from the broker in real-time and
fetch data from the database. A first solution is that the device will first publish its data to the
broker, then it will send an HTTP request to the database web service to save the data. The
device needs to implement two clients for this solution: an MQTT and an HTTP client.

<!-- prettier-ignore -->
{{< mermaid >}}
flowchart LR
    subgraph DeviceEndpoint [Device Endpoint]
        E[Sensor] --> F
        E --> G
        F[MQTT]
        G[HTTP]
    end
    F --> B[MQTT Broker]
    G --> C[Database <br> Webservice]
    B <--> H
    C <--> I
    subgraph WebAppEndpoint [Web App Endpoint]
        H[MQTT]
        I[HTTP]
        H --> K[Client]
        I --> K
    end
{{< /mermaid >}}

Another way is that the device will send or publish its data to the broker, the broker will
reroute it to all connected subscribers. The API Engine is another related subscriber which
accepts the data and stores it in the database. So the HTTP client is decoupled from the
device and implemented as a backend service. The latter can be crucial for developing
constrained and lightweight IoT devices with limited resources like CPU and memory.

<!-- prettier-ignore -->
{{< mermaid >}}
flowchart LR
    subgraph DeviceEndpoint [Device Endpoint]
        E[Sensor] --> F
        F[MQTT]
    end
    subgraph APIEngine [API Engine]
        DD[Database]
        DD <--> QQ[MQTT]
        DD <--> KK[HTTP]
    end
    subgraph WebAppEndpoint [Web App Endpoint]
        H[MQTT]
        I[HTTP]
        H --> K[Client]
        I --> K
    end
    F --> B[MQTT Broker]
    B <--> QQ
    KK <-->I
    B --> H
{{< /mermaid >}}

# With a Realtime Database

A real-time database is a system that uses real-time processing to handle workloads whose
state is constantly changing. Real-time processing differs from traditional databases
containing persistent data, primarily unaffected by time.

<!-- prettier-ignore -->
{{< mermaid >}}
flowchart LR
    A[Sensor] --> B[Realtime Database]
    B --> C[Client 1]
    B --> D[Client 2]
    B --> E[...]
    B --> F[Client n]
{{< /mermaid >}}

In the case of a Realtime Database, clients will be connected to the database and maintain
an open bidirectional connection via WebSockets. Then if any client pushes data to the
database, it will be triggered and inform all connected clients about the change by sending
them the newly saved data. The functionality is analogous to the MQTT broker reaction,
sending the message it receives from a publisher to all subscribers. The difference this time
is the addition of the persistent data part, which is the database. There is no need to route
messages using other protocols; a Realtime Database will take care of routing plus perform
its normal database function.

In the Digital Twin context, you can now connect the device to the Realtime Database and
make it push data periodically to the database. On the other part of the system, you have a
web application connected to the same service as the device and will receive new data
whenever there is a change in the database.
