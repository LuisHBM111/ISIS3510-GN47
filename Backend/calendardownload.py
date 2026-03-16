import pandas as pd
from icalendar import Calendar
from datetime import datetime

def ics_to_dataframe(file_path):
    with open(file_path, 'rb') as f:
        calendar = Calendar.from_ical(f.read())

    event_list = []

    for component in calendar.walk():
        if component.name == "VEVENT":
            event = {
                'summary': str(component.get('summary')),
                'start': component.get('dtstart').dt,
                'end': component.get('dtend').dt if component.get('dtend') else None,
                'location': str(component.get('location')),
                'description': str(component.get('description'))
            }
            event_list.append(event)

    return pd.DataFrame(event_list)

def location_list(df: pd.DataFrame):
    locations = []
    timeframe = []
    for i in df['location']:
        edificio=(i.split('Salón: ')[1]).split(' ')[0]
        locations.append(edificio)
    for i in df['summary']:
        timeframe.append(i)
    return locations,timeframe

df = ics_to_dataframe('Backend/SEGUNDO SEMESTRE 2026.ics')

def rebuild_schedule(df):
    # 1. Sort by start time so the schedule is chronological
    df = df.sort_values(by='start').reset_index(drop=True)
    
    # 2. Calculate duration (in minutes or hours)
    df['duration'] = df['end'] - df['start']
    df['duration_hrs'] = df['duration'].dt.total_seconds() / 3600
    
    # 3. Extract the specific day for easy grouping
    df['date'] = df['start'].dt.date
    df['start_time'] = df['start'].dt.time
    
    # Reorder for a "Schedule" feel
    schedule_df = df[['date', 'start_time', 'duration_hrs', 'location']]
    print(len(df))
    
    # Calculate the gap between the end of one event and the start of the next
    df['gap_until_next'] = df['start'].shift(-1) - df['end']
    
    # Filter for gaps on the same day (to avoid counting the overnight gap)
    df['is_same_day'] = df['date'] == df['start'].shift(-1).dt.date
    df.loc[~df['is_same_day'], 'gap_until_next'] = pd.NaT
    return schedule_df

def horarios_dia(df):
    schedule_data = rebuild_schedule(df)
    dict={}
    for i in range(len(schedule_data)):
        dict[schedule_data['date'][i]] = []
    for i in range(len(schedule_data)):
        b=schedule_data['location'][i].split('Salón: ')[1].split(' ')[0]
        dict[schedule_data['date'][i]].append(b)
    print(dict)
    return dict
