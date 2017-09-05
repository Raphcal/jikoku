//
//  Shape.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import UIKit
import Melisse

class Shape : Equatable, Hashable {
    static let circle: Shape = CircleShape()
    static let round: Shape = RoundShape()
    static let triangular: Shape = TriangularShape()
    static let diamond: Shape = DiamondShape()
    static let pentagonal: Shape = PathShape(path: "12.1657442 0 51.5051526 0 64 39.6682699 31.9865923 64 0 39.5673202")
    static let brushRound: Shape = PathShape(path: "17.3743024 39.7159628 13.8084547 36.6407137 14.8773082 36.9272426 12.6983715 34.7243997 14.5273756 36.0589941 12.4814826 33.9226729 11.111895 30.6960173 11.111895 29.489616 10.2578516 27.6935264 10.0437344 24.9034203 10.2758679 22.6562295 11.0436408 19.5605387 12.0501301 18.1885258 11.9510402 17.2731576 12.5597844 16.4163425 13.7149084 15.8907506 13.3632434 15.1877672 15.4444762 14.14871 16.600986 12.8058004 20.8545726 11.0301523 22.2026792 11.0221836 26.0602529 10.8777065 26.9714635 10.4421963 31.0746829 11.1812123 34.5112981 12.7957528 38.2257806 16.1017496 39.9983104 18.7550008 40.9001663 21.2513021 41.3924972 24.372285 41.6350248 25.9130278 41.664821 26.8183485 41.0488011 27.4669364 40.5661713 30.1045966 39.6885681 32.7547296 38.2722073 34.5574021 34.9371072 37.3876985 33.1676956 38.2801998 32.7321854 38.8134139 28.931086 40.0281304 24.7866369 40.4307261 22.9863896 40.0555014 21.7391051 39.2683263 20.8026024 39.4041417 19.5851141 39.0261452 18.0280874 39.0261452 16.4388391 39.8375731 15.4642248 40.853417 14.7536191 41.2272559 14.5426202 41.9607284 13.9220962 42.6602471 13.6722928 44.2449913 13.8153841 45.4895041 15.1312692 47.2668844 16.8310407 48.4244337 20.1557468 49.8612361 23.7524301 50.7721003 26.5359533 50.7679427 31.3917011 50.5323445 33.7140755 50.0019021 35.0060543 49.7617999 39.9310956 47.4428901 45.297537 43.4540051 48.0325547 40.2962966 49.7430668 37.6828892 50.9297194 34.6675789 51.9057195 30.6118256 52.4853603 26.5927979 52.7971814 22.9268209 52.3824593 19.7012047 51.3496385 16.021369 49.8348808 12.8820233 47.7571127 9.82340462 45.3810358 7.30458292 47.7304347 10.6261708 45.1776591 7.8024573 42.9190349 5.89792321 40.3232973 3.97641219 37.2185984 2.54272798 35.1720124 1.75485996 33.691555 0.850925184 32.9130416 0.850925184 29.3624385 0 26.2670942 0.117452621 23.2538628 0.452833557 21.9961843 0.266087354 19.910794 1.04529368 18.4597864 1.04529368 15.548763 2.02545139 14.8547878 2.81470529 12.0958638 4.15692197 12.6879775 3.10365953 9.37020078 4.88589045 7.53010972 6.35803259 3.57691088 10.6639358 1.81512157 13.160237 2.67228317 12.6218259 3.76014657 10.9597512 6.36792545 8.08685485 5.95456825 8.93089124 3.70599258 11.5842543 2.63111798 13.1997571 1.24153031 13.5458321 1.24134797 14.8475335 0.554668115 15.8664307 1.16002582 15.9605164 0.645836444 18.0039634 0.0920800124 21.4703656 0 23.6447302 0.0962737556 26.7369776 2.14117938 32.6694831 0.849324154 27.1793263 1.90250069 30.4121553 2.9739109 32.8321274 2.09431886 29.6231846 1.52396979 27.4701533 1.30188374 25.9286792 1.38867227 24.191203 1.45960495 22.7711553 1.65798723 24.5516728 1.75644903 25.3555951 1.96285413 25.6487924 2.00333286 26.8689894 2.33263287 27.4854696 2.37183525 28.6881622 3.29172369 30.065898 3.77509817 31.9975725 4.00265432 33.3029207 4.07868871 33.9509452 5.38057245 35.2335012 4.58594929 33.4243569 3.31688615 28.2704289 3.7090923 28.1743375 3.50998067 25.4436637 4.41400582 28.620333 5.20206486 30.5128051 5.51258419 31.7632699 6.90673028 34.9758595 8.646222 37.4131536 11.0255331 39.7096838 11.3838246 38.9936478 10.3813376 38.6202223 8.57164631 36.3658119 7.65066385 35.1627546 6.67789777 32.1618579 8.49214752 35.5905164 10.2427618 37.798978 11.4259444 38.5726324 9.53292517 36.4360115 8.46880843 34.3136128 11.4917679 38.2161643 13.1450144 39.683792 14.3996729 40.0457303 13.5831694 39.1987765 11.7601675 37.4722307 10.6121759 36.2131961 10.6488255 35.4785617 11.9627435 37.2257115 13.6272948 38.4672418 15.7500582 39.9304935 15.117897 39.1353234 11.9306522 36.6717728 10.9934418 34.8919847 10.2258045 34.0550594 9.01563607 30.8612505 10.380973 33.1083675 10.7709911 34.2450542 11.605546 35.4284191 12.0564645 36.2394526 12.6820616 36.4664617 14.0196833 37.9213259 15.0497031 38.7046442")
    static let arrow: Shape = PathShape(path: "15.5 0 31 63 15.5 51.9596208 0 63")
    static let roundedArrow: Shape = SVGPathShape(path: "M15.5,0 L31,63 C31,63 23.25,51.9596208 15.5,51.9596208 C7.75,51.9596208 0,63 0,63 L15.5,0 Z", size: Size(width: 32, height: 63))
    static let powerWave: Shape = SVGPathShape(path: "M218,340 C218,340 219.013032,326 233,326.066452 C246.986968,326.132903 248,340 248,340 L248,345.295557 L242.847815,340.934244 L240.349125,345.294323 L236,341.535277 L233,349.786526 L230,341.445899 L226.384171,343.96402 L223.775383,340.419998 L218,344.921269 L218,340 Z", size: Size(width: 32, height: 25))
    
    var hashValue: Int {
        return 1
    }
    
    open func addPath(in rectangle: CGRect, to context: CGContext) {
        // Pas de traitement.
    }
    
    static let all = [Shape.round, .triangular, .diamond]
    
    static var random: Shape {
        return Melisse.random(itemFrom: all)
    }
    
    static func ==(lhs: Shape, rhs: Shape) -> Bool {
        if let lhs = lhs as? TextShape, let rhs = rhs as? TextShape {
            return lhs == rhs
        }
        else if let lhs = lhs as? PathShape, let rhs = rhs as? PathShape {
            return lhs == rhs
        }
        else if let lhs = lhs as? SVGPathShape, let rhs = rhs as? SVGPathShape {
            return lhs == rhs
        }
        return type(of: lhs) == type(of: rhs)
    }
}
