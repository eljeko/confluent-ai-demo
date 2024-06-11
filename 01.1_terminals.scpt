#!/usr/bin/osascript
on run argv
  set BASEDIR to item 1 of argv as string
  tell application "iTerm2"
    # open first terminal start produce to produce zendesk tickets topic support-ticket
    tell current session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-produce-events.sh"
        split horizontally with default profile
        split vertically with default profile
        split vertically with default profile
    end tell
    # open second terminal and start genAIKafkaConsumer.sh
    tell second session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01_start_genAIKafkaConsumer.sh"
    end tell
    # open third terminal and consume support-ticket-summary
    tell third session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-consumer-ticket-actions.sh"
    end tell
    # open fourth terminal and open Flink Shell
    tell fourth session of current tab of current window
        write text "cd " & BASEDIR
        write text "bash ./01-flink-shell.sh"
    end tell
  end tell
end run