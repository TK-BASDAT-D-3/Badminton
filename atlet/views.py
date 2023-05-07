from django.shortcuts import render, redirect


def show_atlet(request):
    return redirect("atlet_index")

def show_daftar_event(request):
    return render(request, 'daftar_event.html', {})

def show_enrolled_event(request):
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
    context = {"sponsors": ["CV Usamah Halimah",
                           "PT Sihombing Tbk",
                           "UD Susanti Wijaya",
                           "CV Gunawan"]}
    return render(request, 'daftar_sponsor.html', context)