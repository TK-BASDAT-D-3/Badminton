from django.shortcuts import render, redirect
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse

from .repository import *


def show_landing(request):
    return render(request, 'base.html', {})


def show_register(request):
    return render(request, 'register.html', {})


def register_atlet(request):
    if request.method == 'POST':
        # Get the data from the form
        name = request.POST.get('nama')
        email = request.POST.get('email')
        country = request.POST.get('negara')
        birth_date = request.POST.get('tanggal_lahir')
        play = request.POST.get('play')
        height = request.POST.get('tinggi_badan')
        gender = request.POST.get('jenis_kelamin')

        # TODO: Implement logic to handle the data, i.e. store in database

        return JsonResponse({'status': 'success'})
    
    return render(request, 'register_atlet.html')

def register_umpire(request):
    if request.method == 'POST':
        name = request.POST.get('nama')
        email = request.POST.get('email')
        country = request.POST.get('negara')

        return JsonResponse({'status': 'success'})
    return render(request, 'register_umpire.html')

def register_pelatih(request):
    if request.method == 'POST':
        name = request.POST.get('nama')
        email = request.POST.get('email')
        country = request.POST.get('negara')
        categories = request.POST.getlist('kategori[]')
        start_date = request.POST.get('tanggal_mulai')

        return JsonResponse({'status': 'success'})
    return render(request, 'register_pelatih.html')

def show_login(request):
    return render(request, 'login.html', {})


def show_pertandingan(request):
    return render(request, 'pertandingan.html', {})


def daftar_atlet(request):
    return render(request, "daftar_atlet.html")


def show_list_atlet(request):
    return render(request, "list_atlet.html")


def show_dashboard_atlet(request):
    return render(request, "dashboard_atlet.html")


def show_dashboard_pelatih(request):
    return render(request, "dashboard_pelatih.html")


def show_dashboard_umpire(request):
    return render(request, "dashboard_umpire.html")


def buat_ujian_kualifikasi(request):
    return render(request, "buat_ujian_kualifikasi.html")

def list_ujian_kualifikasi(request):
    context = get_list_ujian_kualifikasi()
    return render(request, "list_ujian_kualifikasi.html", context)

def riwayat_ujian_kualifikasi(request):
    context = get_all_riwayat_ujian_kualifikasi()
    return render(request, "riwayat_ujian_kualifikasi.html",context)

@csrf_exempt
def tes_ujian_kualifikasi(request, tahun, batch, tempat, tanggal):
    return render(request, "tes_ujian_kualifikasi.html")

def add_ujian_kualifikasi(request, tahun, batch, tempat, tanggal):
    insert_ujian_kualifikasi(tahun, batch, tempat, tanggal)
    return render(request, "list_ujian_kualifikasi.html")

def trigger_ujian_kualifikasi(request, lulus):
    if lulus:
        return JsonResponse({"status": "lulus"}, status=200)
    else:
        return JsonResponse({"status": "ga lulus"}, status=200)
