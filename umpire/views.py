from django.http import JsonResponse
from .db_functions import get_all_event_data, get_event_data, get_peserta_kompetisi_data, get_pemenang_data_from_match_id, get_peserta_kalah_data_from_match_id
from django.shortcuts import render

def show_pilih_event(request):
    # tarik event yang diadakan di stadium
    # data = umpire_db.get_all_event_data()
    # context = {'events': data}
    data = get_all_event_data()
    context = {'events': data}
    return render(request, 'pilih_event_umpire.html', context)

from .db_functions import get_partai_kompetisi_in_event

def partai_kompetisi_view(request, event_name):
    event_data = get_event_data(event_name)
    context = {
        'event': event_data
    }
    return render(request, 'pilih_kategori_umpire.html', context)


from django.views.decorators.csrf import csrf_exempt
from .db_functions import insert_new_match_in_event
from datetime import datetime

@csrf_exempt
def insert_match_view(request):
    if request.method == 'POST':
        print(request.POST)
        jenis_babak = request.POST.get('jenis_babak')
        tanggal = datetime.strptime(request.POST.get('tanggal'), '%Y-%m-%d').date() 
        waktu_mulai = datetime.strptime(request.POST.get('waktu_mulai'), '%H:%M:%S').time()
        total_durasi = int(request.POST.get('total_durasi'))
        nama_event = request.POST.get('nama_event')
        tahun_event = int(request.POST.get('tahun_event'))
        id_umpire = request.POST.get('id_umpire')

        insert_new_match_in_event(jenis_babak, tanggal, waktu_mulai, total_durasi, nama_event, tahun_event, id_umpire)
        return JsonResponse({'status': 'success'})
    else:
        return JsonResponse({'status': 'Invalid HTTP method'})
    

from django.core.cache import cache
import random
from datetime import datetime, timedelta

def match_data_view(request, event_name, babak):
    data = get_peserta_kompetisi_data(event_name)
    peserta_kompetisi = data['peserta_kompetisi']
    print(peserta_kompetisi)
    event_data = get_event_data(event_name)

    pairs_needed = {
        'R32': 16,
        'R16': 8,
        'Perempat final': 4,
        'Semifinal': 2,
        'Final': 1
    }

    if len(peserta_kompetisi) < 2:
        return JsonResponse({'error': 'Not enough peserta kompetisi'}, status=400)
    
    babak_keys = list(pairs_needed.keys())
    for babak_key in babak_keys:
        if len(peserta_kompetisi) >= pairs_needed[babak_key] * 2:
            babak = babak_key
            break
    
    random_pairs = []
    while len(peserta_kompetisi) > 1:
        pair = random.sample(peserta_kompetisi, 2)
        random_pairs.append(pair)
        peserta_kompetisi.remove(pair[0])
        peserta_kompetisi.remove(pair[1])

    context = {'match_data': random_pairs, "event_data": event_data, "babak": babak, "starting_time": (datetime.now() + timedelta(hours=7)).strftime("%H:%M:%S"), "tanggal": (datetime.now() + timedelta(hours=7)).strftime("%Y-%m-%d")}
    return render(request, 'pertandingan_umpire.html', context)

def next_babak_match_data_view(request, babak, tanggal, waktu_mulai, event_name):
    data = get_pemenang_data_from_match_id(babak, tanggal, waktu_mulai)
    peserta_kompetisi = data['peserta_kompetisi']
    event_data = get_event_data(event_name)
    random_pairs = []
    while len(peserta_kompetisi) > 1:
        pair = random.sample(peserta_kompetisi, 2)
        random_pairs.append(pair)
        peserta_kompetisi.remove(pair[0])
        peserta_kompetisi.remove(pair[1])

    next_babak = ''
    if babak == 'R32':
        next_babak = 'R16'
    elif babak == 'R16':
        next_babak = 'Perempat final'
    elif babak == 'Perempat final':
        next_babak = 'Semifinal'
    elif babak == 'Semifinal':
        next_babak = 'Final'
    elif babak == 'Final':
        next_babak = 'Selesai'
        return hasil_pertandingan_view(request)
    context = {'match_data': random_pairs, "event_data": event_data, "babak": next_babak, "starting_time": (datetime.now() + timedelta(hours=7)).strftime("%H:%M:%S"), "tanggal": (datetime.now() + timedelta(hours=7)).strftime("%Y-%m-%d")}

    if next_babak == 'Final':
        data_peserta_kalah = get_peserta_kalah_data_from_match_id(babak, tanggal, waktu_mulai)
        peserta_kompetisi = data_peserta_kalah['peserta_kompetisi']
        juara_3_pairs = []
        while len(peserta_kompetisi) > 1:
            pair = random.sample(peserta_kompetisi, 2)
            juara_3_pairs.append(pair)
            peserta_kompetisi.remove(pair[0])
            peserta_kompetisi.remove(pair[1])
        
        context['juara_3_pairs'] = juara_3_pairs
    

    
    return render(request, 'pertandingan_umpire.html', context)

def hasil_pertandingan_view(request):
    return render(request, 'r_hasil_pertandingan_umpire.html')

from django.http import JsonResponse
from .db_functions import add_or_update_point_history
from django.views.decorators.http import require_POST

@require_POST
@csrf_exempt
def update_point_history_view(request):
    peserta_id = request.POST.get('peserta_id')
    babak = request.POST.get('babak')
    kategori = request.POST.get('kategori')
    minggu_ke = request.POST.get('minggu_ke')
    bulan = request.POST.get('bulan')
    tahun = request.POST.get('tahun')

    if not all([peserta_id, babak, kategori, minggu_ke, bulan, tahun]):
        return JsonResponse({'error': 'Missing required parameters'}, status=400)

    add_or_update_point_history(peserta_id, babak, kategori, minggu_ke, bulan, tahun)

    return JsonResponse({'success': True})

from .db_functions import insert_into_game
@csrf_exempt
@require_POST
def insert_game_data(request):
        data = {
            "No_Game": request.POST.get('No_Game'),
            "Durasi": request.POST.get('Durasi'),
            "Jenis_Babak": request.POST.get('Jenis_Babak'),
            "Tanggal": request.POST.get('Tanggal'),
            "Waktu_Mulai": request.POST.get('Waktu_Mulai')
        }

        try:
            insert_into_game(**data)
            return JsonResponse({"status": "success"}, status=200)
        except Exception as e:
            return JsonResponse({"status": "fail", "error": str(e)}, status=400)

from .db_functions import insert_into_peserta_mengikuti_game, insert_into_peserta_mengikuti_match

@csrf_exempt
@require_POST
def insert_peserta_mengikuti_game_view(request):
    data1 = {
        "Nomor_Peserta": request.POST.get('Tim1'),
        "No_Game": request.POST.get('No_Game'),
        "Skor": request.POST.get('SkorTim1')
    }

    data2 = {
        "Nomor_Peserta": request.POST.get('Tim2'),
        "No_Game": request.POST.get('No_Game'),
        "Skor": request.POST.get('SkorTim2')
    }

    try:
        insert_into_peserta_mengikuti_game(**data1)
        insert_into_peserta_mengikuti_game(**data2)
        return JsonResponse({"status": "success"}, status=200)
    except Exception as e:
        return JsonResponse({"status": "fail", "error": str(e)}, status=400)
    
@csrf_exempt
@require_POST
def insert_peserta_mengikuti_match_view(request):
    data1 = {
            "Jenis_Babak": request.POST.get('Jenis_Babak'),
            "Tanggal": request.POST.get('Tanggal'),
            "Waktu_Mulai": request.POST.get('Waktu_Mulai'),
            "Nomor_Peserta": request.POST.get('Nomor_Peserta1'),
            "Status_Menang": request.POST.get('Status_Menang1'),
        }
    
    data2 = {
            "Jenis_Babak": request.POST.get('Jenis_Babak'),
            "Tanggal": request.POST.get('Tanggal'),
            "Waktu_Mulai": request.POST.get('Waktu_Mulai'),
            "Nomor_Peserta": request.POST.get('Nomor_Peserta2'),
            "Status_Menang": request.POST.get('Status_Menang2'),
    }

    try:
        insert_into_peserta_mengikuti_match(**data1)
        insert_into_peserta_mengikuti_match(**data2)
        return JsonResponse({"status": "success"}, status=200)
    except Exception as e:
        return JsonResponse({"status": "fail", "error": str(e)}, status=400)
    
    


