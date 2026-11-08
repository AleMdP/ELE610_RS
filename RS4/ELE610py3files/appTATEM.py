#!/usr/bin/env python3
""" appTATEM.py 
Set up a web-page on the computer that acts as a web-server.
The web-page can be viewed by any web-browser. The page shows a graphical
summary of TATEM log-files in JSON format, the files should be stored on
a catalog on this computer, 'data_path' defined in AppTATEM/getData.py.
This file also uses files on catalog AppTATEM.
"""

import os
import pandas as pd
import dash
from dash import Input, Output
import plotly.graph_objects as go

from AppTATEM.plots import Plots
from AppTATEM.getData import GetData, data_path
from AppTATEM.layout import layout

appTATEM = dash.Dash(__name__, title="TATEM Visualizer")

# --------------------------------------------------
# HTML layout of the application
appTATEM.layout = layout
# --------------------------------------------------

@appTATEM.callback(
    Output('chart', 'figure'),
    [Input('datatable_id', 'selected_rows'),
     Input('dropdown', 'value'), 
     Input('filedropdown', 'value')]
)

def update_plots(chosenRows, dropdownval, filedropdown):
    infoGetter = GetData()
    
    # Manejo si no se ha seleccionado archivo o es la opción general 'allfiles'
    if not filedropdown or filedropdown == 'allfiles':
        masterdf = infoGetter.combineFilesToOneDf()
        eventInfo = infoGetter.getEventInfo(masterdf)
        p = Plots(eventInfo, [], dropdownval)
        if dropdownval == 'eventResults':
            return p.eventResultPlot()
        else:
            return p.scatterAll()
            
    masterdf = infoGetter.fromFileToDF(os.path.join(data_path, filedropdown))
    
    # Caso 1: Ninguna fila seleccionada
    if not chosenRows or len(chosenRows) == 0:
        dfFiltered = infoGetter.getEventInfo(masterdf)
        p = Plots(dfFiltered, chosenRows, dropdownval)
        if dropdownval == 'eventResults':
            return p.eventResultPlot()
        else:
            return p.scatterGivenFile()
            
    # Caso 2: Exactamente UNA fila seleccionada (Detalles de las señales L1, L2, S1, S2, DO)
    elif len(chosenRows) == 1:
        rowIndex = chosenRows[0]
        eventInfo = infoGetter.getEventInfo(masterdf)
        details = infoGetter.getDetails(masterdf)
        
        # Validación de límites para evitar IndexError
        if rowIndex >= len(details):
            p = Plots(eventInfo, chosenRows, dropdownval)
            return p.plotText("successError")
            
        row = details.at[rowIndex, "details"]
        
        # Comprobar de forma segura si 'row' tiene datos utilizables
        has_data = False
        if row is not None:
            if isinstance(row, (list, tuple, dict)):
                has_data = len(row) > 0
            else:
                has_data = not pd.isna(row)
                
        if not has_data:
            p = Plots(eventInfo, chosenRows, dropdownval)
            return p.plotText("successError")
        else: 
            try:
                # Conversión directa evitando llamadas que disparan advertencias de Pylance
                if isinstance(row, dict):
                    rowdf = pd.DataFrame([row])
                elif isinstance(row, list):
                    rowdf = pd.DataFrame(row)
                else:
                    rowdf = pd.DataFrame(list(row))  # type: ignore
                    
                p = Plots(rowdf, chosenRows, dropdownval)
                return p.signal()
            except Exception:
                p = Plots(eventInfo, chosenRows, dropdownval)
                return p.plotText("successError")
                
    # Caso 3: Varias filas seleccionadas
    else:
        eventInfo = infoGetter.getEventInfo(masterdf)
        dfFiltered = eventInfo[eventInfo.index.isin(chosenRows)]
        p = Plots(dfFiltered, chosenRows, dropdownval)
        try: 
            return p.scatterChosen()
        except KeyError:
            return p.plotText("keyError")
# Callback para actualizar la tabla
@appTATEM.callback(
    Output('datatable_id', 'data'),
    Input('filedropdown', 'value')
)
def updateDatatable(filedropdown):
    infoGetter = GetData()
    if not filedropdown or filedropdown == 'allfiles':
        masterdf = infoGetter.combineFilesToOneDf()
    else:
        masterdf = infoGetter.fromFileToDF(os.path.join(data_path, filedropdown))
        
    eventInfo = infoGetter.getEventInfo(masterdf)
    return eventInfo.to_dict('records')

# Callback para destacar los puntos en el circuito/pista
@appTATEM.callback(
    Output('raceTrack', 'figure'),
    Input('datatable_id', 'selected_rows')
)
def updateRacetrack(chosenRows):
    df = GetData()
    p = Plots(df, chosenRows or [], "")
    return p.raceTrack()

# Callback para actualizar la lista desplegable de archivos JSON
@appTATEM.callback(
    Output('filedropdown', 'options'),
    Input('filedropdown', 'value')
)
def updateFileDropdownList(value):
    newFileList = GetData().getReportList()
    filedropdown = [{'label': newFileList[i], 'value': newFileList[i]} for i in range(len(newFileList))]
    filedropdown.append({'label': 'All Files', 'value': 'allfiles'})
    return filedropdown

# Arranque del servidor web local
if __name__ == '__main__':
    appTATEM.run(debug=False)