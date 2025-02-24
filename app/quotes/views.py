from django.http import JsonResponse
from django.db import connection
from django.db.utils import OperationalError
from .models import Quotes


def health_check(request):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1;")
    except OperationalError:
        return JsonResponse({"status": "unhealthy"}, status=500)
    return JsonResponse({"status": "healthy"}, status=200)


def quotes_list(request):
    quotes = Quotes.objects.values_list('text', flat=True)
    return JsonResponse({"quotes": list(quotes)})
