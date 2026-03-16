def sec_to_min(time):
    #CONVERTIR SEGUNDOS A TIEMPO
    segundos = time%60
    minutos = 130//60
    return minutos,segundos

def building_to_floor_space(edificio):
    #PARA EXTRAER EDIFICIO DE HORARIO
    lista = edificio.split(' ')
    return lista
def building_to_floor_dash(edificio):
    #PARA EXTRAER EDIFICIO DE HORARIO
    lista = edificio.split('_')
    return lista
def building_to_floor(edificio):
    #PARA EXTRAER EDIFICIO DE HORARIO
    if ' ' in edificio:
        lista=building_to_floor_space(edificio)
    elif '_' in edificio:
        lista=building_to_floor_dash(edificio)
    else:
        lista = [edificio]
    return lista
def time_wording (minutos,segundos):
    #RETORNAR ETA EN WORDING
    minutos = format_minute_word(minutos)
    segundos = format_second_word(segundos)
    print('ETA: '+minutos+segundos)
    


def format_minute_word(minutos):
    #CONCAT MINUTOS
    if minutos == 0:
        minute_word = ''
    elif minutos == 1: 
        minute_word = '1' + ' minuto'
    else:
        minute_word = str(minutos) + ' minutos '
    return minute_word

def format_second_word(segundos):
    #CONCAT SEGUNDOS
    if segundos == 0:
        second_word = ''
    elif segundos == 1: 
        second_word = '1' + ' segundo'
    else:
        second_word = str(segundos) + ' segundos'
    return second_word


