%% Very basic movie demo
% Opens a screen on the 2nd monitor (if available)
% Opens and plays a movie
% Closes screen

%% PsychToolbox basic setup
AssertOpenGL;
PsychDefaultSetup(2);                           % apply common Psychtoolbox parameters
Screen('Preference', 'SkipSyncTests', 1);       % suppress warnings about VBL timing

%% Keyboard setup
KbName('UnifyKeyNames');                        % improve portability of your code acorss operating systems
activeKeys = KbName('Escape');                  % specify key names of interest in the study
RestrictKeysForKbCheck(activeKeys);             % restrict the keys for keyboard input to the keys we want

%% Screen setup & open
scn = max(Screen('Screens'));                   % find second screen if connected
pwin = Screen('OpenWindow', scn, 0, []);        % open PTB window on selected screen
HideCursor(pwin);                               % hide mouse pointer

%% Open movie file
movie = [ PsychtoolboxRoot 'PsychDemos/MovieDemos/DualDiscs.mov' ]; % use PTB demo movie
pmovie = Screen('OpenMovie', pwin, movie);      % open movie file
Screen('PlayMovie', pmovie, 1);                 % play movie

%% Playback loop: Runs until end of movie or ESC keypress
disp('Press ESC to exit.')
while ~KbCheck
    tex = Screen('GetMovieImage', pwin, pmovie);% wait for, and get texture handle for, next movie frame
    if tex<=0                                   % if texture returned is negative movie has ended - break out
        break;
    end
    Screen('DrawTexture', pwin, tex);           % draw next movie frame
    Screen('Flip', pwin);                       % display next movie frame
    Screen('Close', tex);                       % release texture
end

%% Tidy up
droppedframes = Screen('PlayMovie', pmovie, 0)  % stop movie (and print how many frames had to be dropped)
Screen('CloseMovie', pmovie);                   % close movie
ShowCursor(pwin);                               % show mouse pointer
RestrictKeysForKbCheck([]);                     % remove restriction on valid keys
sca;                                            % close PTB windows
