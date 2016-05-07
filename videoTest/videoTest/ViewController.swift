//
//  ViewController.swift
//  videoTest
//
//  Created by Ashish on 07/05/16.
//  Copyright © 2016 Ashish. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

   override func viewDidLoad() {
      super.viewDidLoad()
      let width = UIScreen.mainScreen().bounds.size.width
      let height = UIScreen.mainScreen().bounds.size.height
      
      //create source view
      let playerFrame = CGRectMake(0,  height / 2 - (width * 0.68) / 2, width, width * 0.68)
      let sourceView = UIView(frame: playerFrame)
      sourceView.backgroundColor = UIColor.blackColor()
      
      //create image view for displaying screenshot
      let imageView = UIImageView()
      imageView.frame = sourceView.bounds
      sourceView.addSubview(imageView)
      imageView.contentMode = .ScaleAspectFill
      
      //fetch screenshot for the video
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
         let image = self.getPreviewImageForVideoAtURL(NSURL(string: "http://download.prashantmangukiya.com/SwiftVideoPlayer-Data/Big_Buck_Bunny_Trailer.m4v")!, atInterval: 5)
         dispatch_async(dispatch_get_main_queue(), {
            imageView.image = image
            });
         });
      
      //create play icon on the source view
      let playImageView = UIImageView(frame: CGRect(x: sourceView.frame.size.width / 2 - 25, y: sourceView.frame.size.height / 2 - 25, width: 50, height: 50))
      playImageView.image = UIImage(named: "play")
      sourceView.addSubview(playImageView)
      
      //add source view to the main view
      view.addSubview(sourceView)
      
      //add tap gesture on source view
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped))
      sourceView.addGestureRecognizer(tap)
   }
   
   func tapped() {
      let url = NSURL(string: "http://download.prashantmangukiya.com/SwiftVideoPlayer-Data/Big_Buck_Bunny_Trailer.m4v")
      let avc = AVPlayerViewController()
      avc.player = AVPlayer(URL: url!)
      self.presentViewController(avc, animated: true) {
         avc.player?.play()
      }
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   func getPreviewImageForVideoAtURL(videoURL: NSURL, atInterval: Int) -> UIImage? {
      
      let asset = AVAsset(URL: videoURL)
      let assetImgGenerate = AVAssetImageGenerator(asset: asset)
      assetImgGenerate.appliesPreferredTrackTransform = true
      let time = CMTimeMakeWithSeconds(Float64(atInterval), 100)
      do {
         let img = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
         let frameImg = UIImage(CGImage: img)
         return frameImg
      } catch {
         //catch error: return some placeholder image
      }
      return nil
   }


}

