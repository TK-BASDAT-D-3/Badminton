import uuid
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from .db_functions import get_all_atlet_data, get_enrolled_event, unenrolled_event, get_all_atlet_sponsor_data, get_all_sponsor_data, get_all_partai_peserta_kompetisi
from django.db import connection
from django.views.decorators.csrf import csrf_exempt

from utils.query import query

def show_atlet(request):
    data = get_all_atlet_data()
    context = {'atlets': data}
    return render(request, 'atlet_index.html', context)

def un_enrolled_event():
    unenrolled_event()
    # return redirect("enrolled_event_atlet.html")

def show_enrolled_event(request):
    # tarik data event yg didaftar sama atlet yang sedang login
    data = get_enrolled_event()
    print("enrolled")
    print(data)
    context = {'events': data}
    return render(request, 'enrolled_event_atlet.html', context)

def get_atlet_sponsor_data(request):
    name_datas = []
    data_atlet = get_all_atlet_sponsor_data()
    data_sponsor = get_all_sponsor_data()

    for i in range(len(data_atlet)):
        for j in range(len(data_sponsor)):
            if data_atlet[i][1] == data_sponsor[j][0]:
                name_datas.append(data_sponsor[j][1])
    context = {'atlet_sponsors': data_atlet, "sponsors": name_datas}
    return render(request, 'daftar_sponsor_atlet.html', context)

def show_all_partai_peserta_kompetisi(request):
    data = get_all_partai_peserta_kompetisi()
    context = {'partai': data}
    return render(request, 'partai_peserta_kompetisi.html', context)

def show_daftar_event(request):
    # tarik stadium
    rows=query(f"SELECT nama, negara, kapasitas FROM BADUDU.stadium")
    context = {'stadiums':rows, 'test': rows}
    return render(request, 'daftar_event.html', context)

def show_pilih_event(request, stadium):
    # tarik event yang diadakan di stadium
    rows = query(f"SELECT nama_event, total_hadiah, tgl_mulai, kategori_superseries FROM BADUDU.EVENT WHERE nama_stadium = '{stadium}'")
    
    context = {'events':rows, 'stadium': stadium,}
    return render(request, 'pilih_event.html', context)

def show_pilih_kategori(request, stadium, event):
    # tarik partai yang diadakan di event
    # tarik data user, tapi belum terdaftar sebagai ganda di event ini
    curr_event = query(f"""
            SELECT E.nama_event, E.total_hadiah, E.tgl_mulai, E.tgl_selesai, E.kategori_superseries, S.kapasitas, S.nama, S.negara
            FROM BADUDU.EVENT as E, BADUDU.STADIUM as S
            WHERE E.nama_event = '{event}'
                AND E.nama_stadium = S.nama
            """)
    list_women= query(f"""
        SELECT nama, member.id FROM member
        JOIN atlet a on member.id = a.id
        JOIN atlet_kualifikasi ak on a.id = ak.id_atlet
        WHERE member.id NOT IN (
            SELECT id_atlet_kualifikasi from atlet_ganda
            UNION 
            SELECT id_atlet_kualifikasi_2 from atlet_ganda
            )
        AND jenis_kelamin = FALSE;  
        """)
    
    list_men= query(f"""
        SELECT nama, member.id FROM member
        JOIN atlet a on member.id = a.id
        JOIN atlet_kualifikasi ak on a.id = ak.id_atlet
        WHERE member.id NOT IN (
            SELECT id_atlet_kualifikasi from atlet_ganda
            UNION 
            SELECT id_atlet_kualifikasi_2 from atlet_ganda
            )
        AND jenis_kelamin = TRUE;  
        """)
    
    list_both= query(f"""
        SELECT nama, member.id FROM member
        JOIN atlet a on member.id = a.id
        JOIN atlet_kualifikasi ak on a.id = ak.id_atlet
        WHERE member.id NOT IN (
            SELECT id_atlet_kualifikasi from atlet_ganda
            UNION 
            SELECT id_atlet_kualifikasi_2 from atlet_ganda
            );
        """)

    jumlah_peserta = query(f"""
        SELECT jenis_partai, COUNT(*)
        FROM PARTAI_PESERTA_KOMPETISI
        WHERE nama_event = '{event}'
        GROUP BY jenis_partai, nama_event, tahun_event;
    """)

    count_peserta={}
    for peserta in jumlah_peserta:
        jenis=peserta['jenis_partai']
        count=peserta['count']
        count_peserta[jenis]=count


    kapasitas = query(f"SELECT kapasitas FROM STADIUM WHERE nama='{stadium}'")
    kapasitas = kapasitas[0]

    context = {
        'event': curr_event,
        "sex": "woman",
        "men": list_men,
        "women": list_women,
        "both": list_both,
        "kapasitas": kapasitas,
        "jumlah_peserta": count_peserta
    }
    return render(request, 'pilih_kategori.html', context)



@csrf_exempt
def create_atlet_ganda(request):
    form = get_request_body(request)
    print(f"ID: {id}")
    print(f"form: {form}")
    uid = uuid.uuid4()
    
    result =query(f"""
        INSERT INTO ATLET_GANDA (id_atlet_ganda, id_atlet_kualifikasi, id_atlet_kualifikasi_2)
        VALUES ('{uid}', '9be166f7-26c1-403b-b7ed-9533637fd644', '{form.get('atlet_register')}');
    """)
    context={'hasil': result}
    return render(request, 'enrolled_event.html', context)


def show_daftar_sponsor(request):
    # tarik data sponsor yang belum dipunyai sama atlet yang sedang login
    context = {"sponsors": ["CV Usamah Halimah",
                           "PT Sihombing Tbk",
                           "UD Susanti Wijaya",
                           "CV Gunawan"]}
    return render(request, 'daftar_sponsor.html', context)

def get_request_body(request):
    res = {}
    for k, v in request.POST.items():
        res[k]=v
    return res