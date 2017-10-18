//
//  ImageViewController.swift
//  Cassini
//
//  Created by Sung Kim on 10/16/17.
//  Copyright © 2017 Sung Kim. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
    var imageURL: URL?
    {
        didSet
        {
            image = nil
            
            if view.window != nil
            {
                fetchImage()
            }
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Go to internet to get image
    private func fetchImage()
    {
        if let url = imageURL
        {
            spinner.startAnimating()
            // returns immediately because it is asynchronous
            // async - out of time
            DispatchQueue.global(qos: .userInitiated).async
            {
                [weak self] in
                let urlContents = try? Data(contentsOf: url)
                
                if let imageData = urlContents, url == self?.imageURL
                {
                    DispatchQueue.main.async
                    {
                        // memory cycle
                        // self could be nil
                        // if nil, this won't happen
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if image == nil
        {
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet
        {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    // fileprivate - private to everyone in this file
    fileprivate var imageView = UIImageView()
    
    // UIImage doesn't have to show any image
    private var image: UIImage?
    {
        get
        {
            // this is an optional because imageView doesn't have to show anything
            return imageView.image
        }
        set
        {
            imageView.image = newValue
            imageView.sizeToFit()
            // image can be nil
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }

}

extension ImageViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
}
