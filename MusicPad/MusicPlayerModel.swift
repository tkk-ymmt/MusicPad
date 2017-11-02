//
//  MusicPlayerModel.swift
//  MusicPad
//
//  Created by motoki on 2017/09/02.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation
import OpenAL
import AudioToolbox
import AVFoundation

// this class is singleton class.
final class MusicPlayer {
    static let sharedInstance = MusicPlayer()
    let musicFiles = MusicFiles()
    
    let maxCurrentSources: Int = 32
    let macBuffers: Int = 256
    
    var device: OpaquePointer
    var context: OpaquePointer
    var buffers = NSMutableDictionary()
    var sources = NSMutableArray()
    
    var audioSession: AVAudioSession
    var notifcationCenter = NotificationCenter.default

    var tagAndMusic = NSMutableDictionary()
    var playingTagAndSourceID = NSMutableDictionary()
    var MusicAndSourceID = NSMutableDictionary()
 

    init?() {
        print("init start")
        
        // audio is not played unless follow the order.
        device = alcOpenDevice( UnsafePointer<ALCchar>(bitPattern: 0) )//1
        context = alcCreateContext(device, UnsafePointer<ALCint>(bitPattern: 0))//2
        alcMakeContextCurrent(context)//3
        
        audioSession = AVAudioSession.sharedInstance()
        notifcationCenter.addObserver(self.notifcationCenter,
                                      selector: #selector( handelInterruption(_:) ),
                                      name: .AVAudioSessionInterruption,
                                      object: audioSession)
        do {
            try audioSession.setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            print("Failed to setCategory")
            return nil
        }
        
        do {
            try audioSession.setActive(true)
        } catch {
            print("Failed to setActive")
            return nil
        }
        
        // add sourceIDs to souce array: sources
        var sourceID: ALuint = 0
        for _ in 0 ..< maxCurrentSources {
            alGenSources(1, &sourceID)//4
            sources.add(NSNumber(value: sourceID))
            sourceID += 1
            if alGetError() != AL_NO_ERROR {
                print("failed to get source")
                return nil
            }
        }
        
        var tagNumber: Int = 0
        for (name, type) in musicFiles.musicFilesDictionary {
            guard musicFiles.musicFilesDictionary.count < maxCurrentSources else {
                print("the number of music files is bigger than the count of arrays")
                return
            }
            
            let sID = sources.object(at: tagNumber) as! ALuint
            
            print("name is \(name)")
            print("type is \(type)")
            preloadAudioFile(name: name, type: type, sID: sID )
            tagAndMusic.setObject(name, forKey: tagNumber as NSCopying)
            MusicAndSourceID.setObject(sID, forKey: name as NSCopying)
            tagNumber += 1
        }
        
        
        
    }
    
    // for debug
    private func pointer(pointer: UnsafeMutablePointer<ALuint> , name: String)  {
        let b = String(describing: pointer)
        debugPrint("\(name) pointer is \(b)")
        
    }
    
    @objc func handelInterruption( _ notification: NSNotification)
    {
        debugPrint("interrunted!")
        guard  let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSessionInterruptionType(rawValue: typeValue) else {
                return
        }
        
        if type == .began {
            // Interruption began
            // There is no need to call setActive(false)
            alcMakeContextCurrent(nil)
        }
        else if type == .ended {
            guard  let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            
            let options = AVAudioSessionInterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
                // Interruption Ended - playback should resume
                do {
                    try audioSession.setActive(true)
                } catch {
                    debugPrint("In handleInterruption, failed to setActive")
                    return
                }
                alcMakeContextCurrent(context)
            }
        }
    }
    
    private func preloadAudioFile(name: String, type: String, sID sourceID: ALuint) {
        /*この関数内でソースとバッファを一曲ずつ関連づける*/
        debugPrint("preloadAudioFIle start")
        
        if (buffers.object(forKey: name) != nil) {
            return
        }
        
        if (buffers.count > maxCurrentSources) {
            debugPrint("You are trying to create more than 256 buffers! This is not allowed.")
            return
        }
        
        let audioFilePath: NSString = Bundle.main.path(forResource: name, ofType: type)! as NSString
        debugPrint("audioFIlePath is \(audioFilePath)")
        let expendedPath = audioFilePath.expandingTildeInPath
        debugPrint("expandedPath is \(expendedPath)")
        let afid: AudioFileID = openAudioFile(filePath: expendedPath)
        
        var audioFileSizeInBytes: UInt32 = getSizeOfAudioComponent(audioFileID: afid)
        let audioData = UnsafeMutableRawPointer.allocate(bytes: Int(audioFileSizeInBytes), alignedTo: 4)
        let readBytesResult = AudioFileReadBytes(afid, false, 0, &audioFileSizeInBytes, audioData)
        
        guard readBytesResult == 0 else {
            debugPrint("Failed to AudioFileReadBytes")
            return
        }
        
        AudioFileClose(afid)
        
        // generate a outputbuffer and add audio data to the outputbuffer.
        var outputBuffer: ALuint = 0
        alGetError()
        alGenBuffers(1, &outputBuffer)
        if alGetError() != AL_NO_ERROR {
            debugPrint("failed to get error")
        }
        
        alBufferData(outputBuffer, AL_FORMAT_STEREO16, audioData, ALsizei(audioFileSizeInBytes), 44100)
        pointer(pointer: &outputBuffer, name: "outputBuffer")
      
        // add the bufferID to bufferID array: buffers
        buffers.setValue(NSNumber(value: outputBuffer), forKey: name)
        debugPrint("buffer object is \(String(describing: buffers.object(forKey: name)))")
        
        alSourcef(sourceID, AL_PITCH, 1.0)
        alSourcef(sourceID, AL_GAIN, 1.0)
        alSourcei(sourceID, AL_BUFFER, ALint(outputBuffer))
        
        audioData.deallocate(bytes: Int(audioFileSizeInBytes), alignedTo: 4)
    }
    
    
    private func openAudioFile(filePath: String) -> AudioFileID {
        debugPrint("openAudioFile start")
        
        let audioFileURL = URL(fileURLWithPath: filePath)
        
        debugPrint("\(audioFileURL)")
        var afid: AudioFileID?
        let openAudioFIleResult = AudioFileOpenURL(audioFileURL as CFURL, .readPermission, 0, &afid)
        
        if (openAudioFIleResult != 0) {
            debugPrint("In openAudioFile, failed to AudioFileOpenURL")
            //      return
        }
        
        return afid!
    }
    
    private func getSizeOfAudioComponent(audioFileID afid: AudioFileID) -> ALuint {
        debugPrint("getSizeAudioComponent start")
        var audioDataSize: UInt64 = 0
        var propertySize = UInt32(MemoryLayout<UInt64>.size)
        let getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propertySize, &audioDataSize)
        
        if (getSizeResult != 0)
        {
            debugPrint("An error occurred when attempting to determine the size of audio file.")
            //     return
        }
        
        return ALuint(audioDataSize)
        
    }
    
    func playAudio(tag: Int) {
        guard tag < tagAndMusic.count else {
            return
        }
        
        let name = tagAndMusic[tag] as! String
        let sourceID = MusicAndSourceID[name] as! ALuint
        
        if let playingSourceID = playingTagAndSourceID[tag] {//すでにある音源が再生中の時
            var sourceState: ALint = 0
            alGetSourcei(playingSourceID as! ALuint, AL_SOURCE_STATE, &sourceState)
            
            if sourceState != AL_PLAYING {
                alSourceStop(playingSourceID as! ALuint)
            } else {
                playingTagAndSourceID.removeObject(forKey: tag)
            }
        }
        
        alSourcePlay(sourceID)
        
        playingTagAndSourceID.setObject(sourceID, forKey: tag as NSCopying)
        print("pTAS array is \(playingTagAndSourceID)")
    }
    
    private func getDuration(buffer: ALuint) -> Float {
        var size: ALint = 0
        var frequency: ALint = 0
        var channels: ALint = 0
        var bits: ALint = 0
        
        alGetBufferi(buffer, AL_SIZE, &size)
        alGetBufferi(buffer, AL_FREQUENCY, &frequency)
        alGetBufferi(buffer, AL_CHANNELS, &channels)
        alGetBufferi(buffer, AL_BITS, &bits)
        
        return (Float(size)) / ( Float(frequency * channels * bits/8))

    }
    
    
    private func getOffset(source: ALuint) -> Float{
        var offset: Float = 0
        alGetSourcef(source, AL_SEC_OFFSET, &offset)
        return offset
    }
    
    private func getNextAvailableSource() -> ALuint { // 再生中でないソースを見つけてそのidを返している
        debugPrint("getNextAvailableSource start")
        var sourceState: ALint = 0
        
        for sourceID in sources {
            alGetSourcei(sourceID as! ALuint, AL_SOURCE_STATE, &sourceState)
            print("\(sourceID)")
            if (sourceState != AL_PLAYING) {
                print("find source you can use")
                return sourceID as! ALuint
            }
        }
        
        print("NOT find source you can use")
        let sourceID: ALuint = sources.object(at: 0) as! ALuint
        alSourceStop(sourceID)
        return sourceID
    }
    
    func shutDownMusicPlayer()
    {
        // 終了時の処理
        print("shutDownMusicPlayer")
        var source: ALint = 0
        for sourceValue in sources {
            var sourceID: ALuint = sourceValue as! ALuint
            alGetSourcei(sourceID, AL_SOURCE_STATE, &source)
            alSourceStop(sourceID)
            alDeleteSources(1, &sourceID)
        }
        
        let bufferIDs: NSArray = [buffers.allValues]
        for bufferValue in bufferIDs {
            var bufferID: ALuint = bufferValue as! ALuint
            alDeleteBuffers(1, &bufferID)
        }
        buffers.removeAllObjects()
        
        alcDestroyContext(context)
        alcCloseDevice(device)
    }
}
