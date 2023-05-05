from django.shortcuts import render, redirect


def show_landing(request):
    return render(request, 'base.html', {})
