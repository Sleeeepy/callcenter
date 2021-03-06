<button type="button" class="btn-success"><span class="glyphicon glyphicon-earphone"></span> Call us for free!</button>
<div class="panel panel-default">
  <div class="panel-heading"><?php echo $heading_title; ?></div>
  <div class="panel-content" style="text-align: center;"><?php echo $helloworld_value; ?></div>


</div>
<div>
  <script src="//cdn.webrtc-experiment.com/DetectRTC.js"></script>
          <script src="http://simplewebrtc.com/latest.js"></script>
          <script>
          DetectRTC.load(function() {
    console.log(DetectRTC.hasWebcam);
     DetectRTC.hasMicrophone
    DetectRTC.hasSpeakers
     DetectRTC.isScreenCapturingSupported
     DetectRTC.isSctpDataChannelsSupported
     DetectRTC.isRtpDataChannelsSupported
     DetectRTC.isAudioContextSupported
     DetectRTC.isWebRTCSupported
     DetectRTC.isDesktopCapturingSupported
     DetectRTC.isMobileDevice
     DetectRTC.isWebSocketsSupported});
          </script>



          <style>

            #remoteVideos video {
                height: 250px;
                border: 2px;
            }
            #localVideo {
                height: 150px;
            }

            .videoContainer {
                position: relative;
                width: 350px;
                height: 250px;
                float: left;
            }
            .videoContainer video {
                position: absolute;
                width: 100%;
                height: 100%;
            }
            .volume {
                position: absolute;
                left: 15%;
                width: 70%;
                bottom: 2px;
                height: 10px;
            }


            .muted, .paused{
                display: none
                position: absolute
                z-index: 1
                color: #12acef
            }


            .muted{
                left: 0px
                bottom: 10%
                width: 100%
            }

            .paused{
              left: 0px
              top: 40%
              width: 100%
            }


          </style>




          <video id="localVideo"></video><br>
          <meter id="localVolume" min="-45" max="-20" low="-40" high="-25"></meter>
          <button type="button" name="button" id="button1">video</button>
          <button type="button" name="button" id="button2">audio</button>
          <div id="remotes"></div>

          <script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
          <script>

          var webrtc = new SimpleWebRTC({
            // the id/element dom element that will hold "our" video
            localVideoEl: 'localVideo',
            // the id/element dom element that will hold remote videos
            remoteVideosEl: '',
            // immediately ask for camera access
            autoRequestMedia: true
          });
          // we have to wait until it's ready
          webrtc.on('readyToCall', function () {
            // you can name it anything
            webrtc.joinRoom('your awesome room name er-098-098');

          });
          var toggleVideo = true;
          document.getElementById('button1').addEventListener('click',function(){
            if (toggleVideo){
              webrtc.pauseVideo();
            }else{
              webrtc.resumeVideo();
            }
            toggleVideo = !toggleVideo;
          });

          var toggleAudio = true;
          document.getElementById('button2').addEventListener('click',function(){
            if (toggleAudio){
              webrtc.mute();
            }else{
              webrtc.unmute();
            }
            toggleAudio = !toggleAudio;
          });

          // a peer video has been added
          webrtc.on('videoAdded', function (video, peer) {
            console.log('video added', peer);
            var remotes = document.getElementById('remotes');
            if (remotes) {
              var container = document.createElement('div');
              container.className = 'videoContainer';
              container.id = 'container_' + webrtc.getDomId(peer);
              container.appendChild(video);

              // suppress contextmenu
              video.oncontextmenu = function () { return false; };

              remotes.appendChild(container);
            }

            // show the remote volume
            var vol = document.createElement('meter');
            vol.id = 'volume_' + peer.id;
            vol.className = 'volume';
            vol.min = -45;
            vol.max = -20;
            vol.low = -40;
            vol.high = -25;
            container.appendChild(vol);

            // add muted and paused elements
            var muted = document.createElement('span');
            muted.className = 'muted';
            container.appendChild(muted);
            var paused = document.createElement('span');
            paused.className = 'paused';
            container.appendChild(paused);

          });

          // a peer video was removed
          webrtc.on('videoRemoved', function (video, peer) {
            console.log('video removed ', peer);
            var remotes = document.getElementById('remotes');
            var el = document.getElementById(peer ? 'container_' + webrtc.getDomId(peer) : 'localScreenContainer');
            if (remotes && el) {
            remotes.removeChild(el);
            }
          });

          // listen for mute and unmute events
          webrtc.on('mute', function (data) { // show muted symbol
            webrtc.getPeers(data.id).forEach(function (peer) {
              if (data.name == 'audio') {
                $('#videocontainer_' + webrtc.getDomId(peer) + ' .muted').show();
              } else if (data.name == 'video') {
                $('#videocontainer_' + webrtc.getDomId(peer) + ' .paused').show();
                $('#videocontainer_' + webrtc.getDomId(peer) + ' video').hide();
              }
            });
          });

          webrtc.on('unmute', function (data) { // hide muted symbol
            webrtc.getPeers(data.id).forEach(function (peer) {
            if (data.name == 'audio') {
            $('#videocontainer_' + webrtc.getDomId(peer) + ' .muted').hide();
            } else if (data.name == 'video') {
            $('#videocontainer_' + webrtc.getDomId(peer) + ' video').show();
            $('#videocontainer_' + webrtc.getDomId(peer) + ' .paused').hide();
            }
            });
          });

          // local volume has changed
          webrtc.on('volumeChange', function (volume, treshold) {
              showVolume(document.getElementById('localVolume'), volume);
          });
          // remote volume has changed
          webrtc.on('remoteVolumeChange', function (peer, volume) {
              showVolume(document.getElementById('volume_' + peer.id), volume);
          });


          // helper function to show the volume
          function showVolume(el, volume) {
              //console.log('showVolume', volume, el);
              if (!el) return;
              if (volume < -45) volume = -45; // -45 to -20 is
              if (volume > -20) volume = -20; // a good range
              el.value = volume;
          }



          </script>

</div>
