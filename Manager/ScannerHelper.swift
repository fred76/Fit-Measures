//
//  ScannerHelper.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 03/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//
import Foundation
import AVFoundation
import UIKit

class ScannerHelper : NSObject {
    private var viewController : UIViewController!
    private var captureSession : AVCaptureSession?
    private var codeOutputHandler : (_ code: String) -> Void
    var previewAdded = AVCaptureVideoPreviewLayer()
    
    private func createCaptureSession() -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metaDataOutput = AVCaptureMetadataOutput()
            // add device input
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            } else {
                return nil
            }
            // Add metaData output
            if captureSession.canAddOutput(metaDataOutput){
                captureSession.addOutput(metaDataOutput)
                
                if let viewController = self.viewController as? AVCaptureMetadataOutputObjectsDelegate {
                    metaDataOutput.setMetadataObjectsDelegate(viewController, queue: DispatchQueue.main)
                    metaDataOutput.metadataObjectTypes = self.metaObjectTypes()
                }
            }
        }
        catch {
            return nil
        }
        return captureSession
    }
    
    private func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [.qr,
        .code128,
        .code39,
        .code39Mod43,
        .code93,
        .ean13,
        .ean8,
        .pdf417,
        .upce]
    }
    
    func removePreviewLayer(view : UIView){
        previewAdded.removeFromSuperlayer()
    }
    
    private func createPreviewLayer(withCaptureSession captureSession : AVCaptureSession, view : UIView) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        previewAdded = previewLayer
        return previewLayer
    }
    
     init(withViewController viewController : UIViewController, view: UIView, codeOutputHandler : @escaping (String) -> Void) {
        self.viewController = viewController
        self.codeOutputHandler = codeOutputHandler
        super.init()
        
        if let captureSession = self.createCaptureSession() {
            self.captureSession = captureSession
            let previewLayer = self.createPreviewLayer(withCaptureSession: captureSession, view: view)
            view.layer.addSublayer(previewLayer)
        
        }
    }
    
    func requestCaptureSessioStartRunning(){
        guard let captureSession = self.captureSession else {
            return
        }
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func requestCaptureSessioStopRunning(){
        guard let captureSession = self.captureSession else {
            return
        }
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func scannerHelperDelegate(_ output: AVCaptureMetadataOutput, didOutput metadateObjects : [AVMetadataObject], from connection : AVCaptureConnection) {
        self.requestCaptureSessioStopRunning()
        if let metadataObject = metadateObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            guard let stringValue = readableObject.stringValue else {
                return
            }
            self.codeOutputHandler(stringValue)
        }
    }
}
