from rest_framework import serializers
from .models import CustomUser


class CustomUserSerializer(serializers.ModelSerializer):
    """
    Serializer for CustomUser model.
    """
    class Meta:
        model = CustomUser
        fields = ["id", "email", "username", "first_name", "last_name"]
        read_only_fields = ["id"]
