//
//  ChatRightTableViewCell.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 20.07.2022.
//

import AVKit
import UIKit

final class ChatRightTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelDescription: UILabel! {
        didSet {
            labelDescription.textColor = CustomConfiguration.config.messageColor
        }
    }
    @IBOutlet private weak var labelUser: UILabel! {
        didSet {
            labelUser.text = CustomConfiguration.config.incomingText
            labelUser.textColor = CustomConfiguration.config.incomingTextColor
        }
    }
    @IBOutlet private weak var labelTime: UILabel!
    @IBOutlet private weak var viewContent: UIView! {
        didSet {
            viewContent.clipsToBounds = true
            viewContent.layer.cornerRadius = 10
            viewContent.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
            viewContent.makeShadow()
            viewContent.backgroundColor = CustomConfiguration.config.messageBoxColor
        }
    }
    @IBOutlet private weak var ivUser: UIImageView! {
        didSet {
            switch CustomConfiguration.config.incomingIcon {
            case .image(let image):
                ivUser.image = image
            case .url(let url):
                ivUser.setImage(with: url)
            default:
                break
            }
        }
    }
    @IBOutlet private weak var svRecordingInfo: UIStackView!
    @IBOutlet private weak var labelRecordingInfo: UILabel!
    @IBOutlet private weak var buttonStartStop: UILabel!
    private var recordedFileURL: URL?
    private var player = AVPlayer()
    private var isPlaying = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(data: ChatModel) {
        labelDescription.isHidden = true
        svRecordingInfo.isHidden = true
        let textLanguage = TextHelper().getTextLanguage(data.text)
        labelUser.text = CustomConfiguration.config.incomingText
        labelTime.text = Date().getAsString(.yyyyMMddHHmm)
        if let recordedFileURL = data.recordedFileURL {
            svRecordingInfo.isHidden = false
            configurePlayer(recordedFileURL: recordedFileURL)
            self.recordedFileURL = recordedFileURL
        } else {
            labelDescription.isHidden = false
            labelDescription.text = data.text
            labelDescription.semanticContentAttribute = textLanguage?.semanticContentAttribute ?? .forceLeftToRight
        }
    }
    
    @IBAction private func onButtonStartStopClicked(_ sender: Any) {
        playPauseRecord()
    }
    
    private func configurePlayer(recordedFileURL: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print(error.localizedDescription)
        }
        
        player.seek(to: CMTime.zero)
        player.pause()
        let playerItem = AVPlayerItem(url: recordedFileURL)
        NotificationCenter.default.addObserver(self, selector: #selector(playerFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        player.replaceCurrentItem(with: playerItem)
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { time in
            if self.player.currentItem?.status == .readyToPlay {
                let time: Float64 = CMTimeGetSeconds(self.player.currentTime())
                let totalTimeString = self.secondsToHoursMinutesSeconds(seconds: time)
                guard let duration: CMTime = self.player.currentItem?.asset.duration else { return }
                let seconds: Float64 = CMTimeGetSeconds(duration)
                let currentSecondString = self.secondsToHoursMinutesSeconds(seconds: seconds)
                self.labelRecordingInfo.text = "\(totalTimeString)/\(currentSecondString)"
            }
        }
    }
    
    private func playPauseRecord() {
        if isPlaying {
            player.pause()
        } else {
            player.seek(to: CMTime.zero)
            player.play()
        }
        isPlaying.toggle()
    }
    
    func secondsToHoursMinutesSeconds(seconds: Double) -> (String) {
        let (_,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return ("\(Int(min)) : \(Int(60 * secf))")
    }
    
    @objc private func playerFinished(_ sender: NSNotification) {
        isPlaying = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}
