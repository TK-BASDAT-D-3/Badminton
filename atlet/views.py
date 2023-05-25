from django.shortcuts import render, redirect
from .db_functions import get_all_atlet_data, get_enrolled_event, unenrolled_event, get_all_atlet_sponsor_data, get_all_sponsor_data, get_all_partai_peserta_kompetisi

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
    # tarik data stadium
    context = {"stadiums": [
        {"nama": "National Center",
         "negara": "Somalia",
         "kapasitas":58534},
        {"nama": "Private Palace",
         "negara": "Mozambik",
         "kapasitas":50386},
        {"nama": "Provincial Dome",
         "negara": "Lithuania",
         "kapasitas":12568},
        {"nama": "State Arena",
         "negara": "Islandia",
         "kapasitas":39660},
    ]}
    return render(request, 'daftar_event.html', context)

def show_pilih_event(request, stadium):
    # tarik event yang diadakan di stadium
    context = {"events": [
        {
            "nama_event": "All England Open",
            "hadiah": 3100,
            "tanggal_mulai":"03/05/2021",
            "superseries": "S1000",
            "kapasitas": 8,
            "terisi": 3
        },
        {
            "nama_event": "China Open",
            "hadiah": 3100,
            "tanggal_mulai":"09/02/2020",
            "superseries": "S1000",
            "kapasitas": 8,
            "terisi": 5
        },
    ]}
    return render(request, 'pilih_event.html', context)

def show_pilih_kategori(request, stadium, event):
    # tarik partai yang diadakan di event
    # tarik data user, tapi belum terdaftar sebagai ganda di event ini
    context = {
        "event": {
            "nama_event": "All England Open",
            "hadiah": 3100,
            "tanggal_mulai":"03/05/2021",
            "tanggal_selesai": "22/08/2021",
            "superseries": "S1000",
            "kapasitas": 8,
            "terisi": 3,
            "stadium": "State Arena",
            "negara": "Islandia" 
        },
        "sex": "woman",
        "men": ["Lega Putra", "Alambana Irawan", "Jasmani Pratama"],
        "women": ["Tiara Situmorang", "Aisyah Thamrin", "Kiandra Haryah"]
    }
     
    return render(request, 'pilih_kategori.html', context)



def show_daftar_sponsor(request):
    # tarik data sponsor yang belum dipunyai sama atlet yang sedang login
    context = {"sponsors": ["CV Usamah Halimah",
                           "PT Sihombing Tbk",
                           "UD Susanti Wijaya",
                           "CV Gunawan"]}
    return render(request, 'daftar_sponsor.html', context)