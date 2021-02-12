from time import sleep
import datetime

#better to use Class(Enum) here?
EXIT = 0
START_TIMER = 1
MODIFY_TIMER = 2
TOGGLE_AUDIO = 3

duration = 3 #in seconds
is_audio_enabled = False

def format_time(secs):
    return str(datetime.timedelta(seconds=secs))

def start_timer(duration):
    print("")
    for remaining in range(duration, -1, -1):
        formated_duration = format_time(remaining)
        # print(f"\r\033[1A\033[0K{i}") #cursor jumps every second and some characters aren't handled by cmd prompt
        print(f"\r{formated_duration} ", flush=True, end='') #flush to have clean input once timer is done. cursor is still ugly - can we hide it?
        sleep(1)
    if is_audio_enabled: print('\007') # plays error sound. doesn't work in vscode terminal. needs testing in linux
    print("\nTimer Complete.")

def display_menu(duration, is_audio_enabled):
    audio_status = "Enabled" if is_audio_enabled else "Disabled"
    formated_time = format_time(duration)
    print("")
    print("============= Terminal Timer ===============")
    print("Menu:")
    print(f"1 - Start Timer ({formated_time})")
    print("2 - Modify Timer")
    print(f"3 - Toggle Audio ({audio_status})")
    print("0 - Exit")

def get_menu_selection():
    selection = None
    try:
        selection = int(input("Enter Selection: "))
        # may want helper function to find max num in Selection Enum
        if selection < EXIT or selection > TOGGLE_AUDIO: raise Exception
    except:
        selection = -1
    return selection

def get_positive_int(prompt):
    output=None
    while True:
        try:
            output = int(input(prompt))
            if output < 0: raise Exception
            break
        except:
            print("Invalid Input. Must be a positive Integer.")
    return output

if __name__ == "__main__":
    while 1:
        display_menu(duration, is_audio_enabled)
        selection = get_menu_selection()
        if selection == 1:
            start_timer(duration)
        elif selection == 2:
            hours = get_positive_int("Enter total hours: ")
            mins = get_positive_int("Enter total mins: ")
            duration = hours*3600+mins*60
        elif selection == 3:
            is_audio_enabled = not is_audio_enabled
            print("Audio Enabled.") if is_audio_enabled else print("Audio Disabled.")
        elif selection == -1:
            print ("Invalid Input.")
        elif selection == 0:
            print ("Goodbye.")
            print ("======================================")
            quit()
   