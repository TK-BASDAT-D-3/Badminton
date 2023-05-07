from django.shortcuts import render, redirect


def show_atlet(request):
    return redirect("atlet_index")

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

def show_enrolled_event(request):
    # tarik data event yg didaftar sama atlet yang sedang login
    context = {"enrolled_events": [
        {
            "nama_event": "China Open",
            "superseries": "S1000",
            "spesialisasi": "Tunggal Putri",
            "tanggal_mulai": "09/02/2020",
            "tanggal_selesai": "27/02/2020",
            "hadiah": 3100,
            "stadium": "State Arena",
            "kapasitas": 39660
        },
        {
            "nama_event": "All England Open",
            "superseries": "S1000",
            "spesialisasi": "Tunggal Putri",
            "tanggal_mulai": "03/05/2021",
            "tanggal_selesai": "22/08/2021",
            "hadiah": 3100,
            "stadium": "State Arena",
            "kapasitas": 39660
        },
        {
            "nama_event": "Denmark Open",
            "superseries": "S100",
            "spesialisasi": "Ganda Putri",
            "tanggal_mulai": "15/03/2023",
            "tanggal_selesai": "28/07/2023",
            "hadiah": 310,
            "stadium": "Private Palace",
            "kapasitas": 50386
        },
    ]}
    return render(request, 'enrolled_event.html', context)

def show_daftar_sponsor(request):
    # tarik data sponsor yang belum dipunyai sama atlet yang sedang login
    context = {"sponsors": ["CV Usamah Halimah",
                           "PT Sihombing Tbk",
                           "UD Susanti Wijaya",
                           "CV Gunawan"]}
    return render(request, 'daftar_sponsor.html', context)