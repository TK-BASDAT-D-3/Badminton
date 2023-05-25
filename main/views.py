from django.shortcuts import render, redirect
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse

from .repository import *


def show_landing(request):
    return render(request, 'base.html', {})


def show_register(request):
    return render(request, 'register.html', {})


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
