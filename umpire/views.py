from django.http import JsonResponse
from .db_functions import get_all_event_data, get_event_data, get_peserta_kompetisi_data
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

from .db_functions import update_durasi_in_match

@csrf_exempt
def update_durasi_view(request):
    if request.method == 'POST':
        jenis_babak = request.POST.get('jenis_babak')
        tanggal = request.POST.get('tanggal')
        waktu_mulai = request.POST.get('waktu_mulai')
        new_durasi = request.POST.get('new_durasi')

        if not all([jenis_babak, tanggal, waktu_mulai, new_durasi]):
            return JsonResponse({'error': 'Missing required parameters'}, status=400)

        update_durasi_in_match(jenis_babak, tanggal, waktu_mulai, new_durasi)

        return JsonResponse({'status': 'success'})
    
from .db_functions import get_peserta_kompetisi_data

def peserta_kompetisi_data_view(request, event_name):
    data = get_peserta_kompetisi_data(event_name)
    return JsonResponse(data)

from django.core.cache import cache
import random
from datetime import datetime, timedelta

def match_data_view(request, event_name, babak):
    data = get_peserta_kompetisi_data(event_name)
    peserta_kompetisi = data['peserta_kompetisi']
    map_id_to_nama = data['map_id_to_nama']
    event_data = get_event_data(event_name)
    # Define the number of pairs needed based on the "babak" argument
    pairs_needed = {
        'R32': 16,
        'R16': 8,
        'Perempat final': 4,
        'Semifinal': 2,
        'Final': 1
    }

    if babak not in pairs_needed:
        return JsonResponse({'error': 'Invalid babak parameter'}, status=400)
    
    if len(peserta_kompetisi) < pairs_needed[babak] * 2:
        return JsonResponse({'error': 'Not enough peserta for the specified babak'}, status=400)
    
    random_pairs = [random.sample(peserta_kompetisi, 2) for _ in range(pairs_needed[babak])]
    context = {'match_data': random_pairs, "map_id_to_nama": map_id_to_nama, "event_data": event_data, "babak": babak, "starting_time": (datetime.now() + timedelta(hours=7)).strftime("%H:%M:%S"), "tanggal": (datetime.now() + timedelta(hours=7)).strftime("%Y-%m-%d")}
    print(context)
    return render(request, 'pertandingan_umpire.html', context)


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
    data = {
        "Nomor_Peserta": request.POST.get('Nomor_Peserta'),
        "No_Game": request.POST.get('No_Game'),
        "Skor": request.POST.get('Skor')
    }

    try:
        insert_into_peserta_mengikuti_game(**data)
        return JsonResponse({"status": "success"}, status=200)
    except Exception as e:
        return JsonResponse({"status": "fail", "error": str(e)}, status=400)
    
@csrf_exempt
@require_POST
def insert_peserta_mengikuti_match_view(request):
    data = {
            "Jenis_Babak": request.POST.get('Jenis_Babak'),
            "Tanggal": request.POST.get('Tanggal'),
            "Waktu_Mulai": request.POST.get('Waktu_Mulai'),
            "Nomor_Peserta": request.POST.get('Nomor_Peserta'),
            "Status_Menang": request.POST.get('Status_Menang'),
        }

    try:
        insert_into_peserta_mengikuti_match(**data)
        return JsonResponse({"status": "success"}, status=200)
    except Exception as e:
        return JsonResponse({"status": "fail", "error": str(e)}, status=400)
    


