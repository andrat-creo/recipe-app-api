from django.test import TestCase

from django.contrib.auth import get_user_model


class ModelTests(TestCase):

    def test_create_user_with_email_successful(self):
        """ ***TEST creating a new user with an email is successful """
        email = "dummy@dummy.com"
        password = "dummyPASSWORD"
        user = get_user_model().objects.create_user(
            email=email,
            password=password
        )

        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))

    def test_new_user_email_normalized(self):
        """ ***TEST if the email for a new user is normalized """
        email = "test@DUMMY.COM"
        user = get_user_model().objects.create_user(email, "test123")

        self.assertEqual(user.email, email.lower())

    def test_new_user_invalid_email(self):
        """ ***TEST if user with no email raises error"""
        with self.assertRaises(ValueError):
            get_user_model().objects.create_user(None, "test123")

    def test_create_new_superuser(self):
        """ ***TEST creating a new superuser"""
        user = get_user_model().objects.create_superuser(
            "dummy@dummy.com",
            "dummyPASS123"
        )

        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)
