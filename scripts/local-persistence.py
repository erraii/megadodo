"""Run through manage.py shell, before and after Compose down/up."""
import os
from dictionary.models import Author, Entry, Topic

title = "local runtime persistence check"
content = "development database survives container recreation"
if os.environ.get("PERSISTENCE_CREATE") == "1":
    author, created = Author.objects.get_or_create(
        username="runtime-check",
        defaults={"email": "runtime-check@example.invalid", "is_active": True,
                  "is_novice": False, "application_status": "AP"},
    )
    if created:
        author.set_unusable_password()
        author.save()
    topic, _ = Topic.objects.get_or_create(title=title)
    Entry.objects.get_or_create(topic=topic, author=author, content=content)
topic = Topic.objects.get(title=title)
entry = Entry.objects.get(topic=topic, author__username="runtime-check", content=content)
assert not entry.is_draft
print(f"Persistence OK: topic={topic.pk}, entry={entry.pk}, author={entry.author_id}")
