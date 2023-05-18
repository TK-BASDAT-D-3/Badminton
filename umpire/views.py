from django.http import JsonResponse
from .db_functions import get_all_event_data

def event_data_view(request):
    data = get_all_event_data()
    return JsonResponse({'event_data': data})

from .db_functions import get_partai_kompetisi_in_event

def partai_kompetisi_view(request, event_name):
    data = get_partai_kompetisi_in_event(event_name)
    return JsonResponse({'partai_kompetisi_data': data})


from django.views.decorators.csrf import csrf_exempt
from .db_functions import insert_new_match_in_event
import datetime

@csrf_exempt
def insert_match_view(request):
    if request.method == 'POST':
        print(request.POST)
        jenis_babak = request.POST.get('jenis_babak')
        tanggal = datetime.datetime.strptime(request.POST.get('tanggal'), '%Y-%m-%d').date() 
        waktu_mulai = datetime.datetime.strptime(request.POST.get('waktu_mulai'), '%H:%M:%S').time()
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

def match_data_view(request, event_name, babak):
    data = get_peserta_kompetisi_data(event_name)
    peserta_kompetisi = data['peserta_kompetisi']
    atlet_ganda_data = data['atlet_ganda_data']
    atlet_kualifikasi_data = data['atlet_kualifikasi_data']
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
    
    # previous_babak = list(pairs_needed.keys())[list(pairs_needed.values()).index(pairs_needed[babak]) - 1]

    # if cache.get(f'{event_name}_{previous_babak}_winners'):
    #     peserta_kompetisi = cache.get(f'{event_name}_{previous_babak}_winners')

    if len(peserta_kompetisi) < pairs_needed[babak] * 2:
        return JsonResponse({'error': 'Not enough peserta for the specified babak'}, status=400)
    
    random_pairs = [random.sample(peserta_kompetisi, 2) for _ in range(pairs_needed[babak])]
    winners = [random.choice(pair) for pair in random_pairs]
    # cache.set(f'{event_name}_{babak}_winners', winners, None)
    return JsonResponse({'match_data': random_pairs, 'winners': winners, 'atlet_ganda_data': atlet_ganda_data, 'atlet_kualifikasi_data': atlet_kualifikasi_data})


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
