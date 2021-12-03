# Peer To Peer Connection.

This is chat application uses Apple's **Network** framework. To send/receive messages we create a bidirectional data connection between two users. Data flows between a local endpoint and a remote endpoint. 

---

## Demonstrated Objects and Protocols Table

| Object       | Description                                                                    |
|--------------|--------------------------------------------------------------------------------|
| [NWConnection](https://developer.apple.com/documentation/network/nwconnection/) | A bidirectional data connection between a local endpoint and a remote endpoint |
| [NWListener](https://developer.apple.com/documentation/network/nwlistener)   | An object you use to listen for incoming network connections.                  |
| [NWBrowser](https://developer.apple.com/documentation/network/nwbrowser)    | An object you use to browse for available network services.                    |
| [NWProtocolFramer](https://developer.apple.com/documentation/network/nwprotocolframer)| A customizable network protocol for defining application message parsers.   |
| [NWProtocolFramerImplementation](https://developer.apple.com/documentation/network/nwprotocolframerimplementation)| A protocol to which your classes can conform in order to implement a custom framing protocol.|

___

## Demo Videos

Create Host | Join Host
:-: | :-:
<video src='https://user-images.githubusercontent.com/42291322/144649229-78714dea-cdd2-4670-b384-268cc37ea12e.mov' width=375/> | <video src='https://user-images.githubusercontent.com/42291322/144649235-adc03327-6b8d-43b9-a439-ea8cb5776e27.mov' width=375/>


