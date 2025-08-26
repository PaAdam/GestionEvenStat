import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { EventService } from '../../services/event.service';
import { Event } from '../../models/event';

@Component({
  selector: 'app-event-list',
  templateUrl: './event-list.component.html',
  styleUrls: ['./event-list.component.scss']
})
export class EventListComponent implements OnInit {
  events: Event[] = [];
  eventForm: FormGroup;
  currentEventId: number | null = null;
  
  displayedColumns: string[] = ['name', 'date', 'location', 'description', 'organizer', 'actions']; // Colonnes du tableau

  constructor(private eventService: EventService, private fb: FormBuilder) {
    this.eventForm = this.fb.group({
      name: ['', Validators.required],
      date: ['', Validators.required],
      location: ['', Validators.required],
      description: ['', Validators.required],
      organizer: ['', Validators.required],
    });
  }

  ngOnInit(): void {
    this.loadEvents();
  }

  loadEvents(): void {
    this.eventService.getEvents().subscribe((data) => {
      this.events = data;
    });
  }

  addEvent(): void {
    if (this.eventForm.valid) {
      const newEvent: Event = this.eventForm.value;
      this.eventService.addEvent(newEvent).subscribe(() => {
        this.loadEvents(); // Rafraîchir la liste des événements
        this.eventForm.reset(); // Réinitialiser le formulaire
      });
    }
  }

  editEvent(event: Event): void {
    this.currentEventId = event.id ?? null;
    this.eventForm.patchValue({
      name: event.name,
      date: event.date,
      location: event.location,
      description: event.description,
      organizer: event.organizer,
    });
  }

  updateEvent(): void {
    if (this.eventForm.valid && this.currentEventId !== null) {
      const updatedEvent: Event = { ...this.eventForm.value, id: this.currentEventId };
      this.eventService.updateEvent(updatedEvent).subscribe(() => {
        this.loadEvents();
        this.eventForm.reset();
        this.currentEventId = null;
      });
    }
  }

  deleteEvent(id?: number): void {
    if (id && confirm('Voulez-vous vraiment supprimer cet événement ?')) {
      this.eventService.deleteEvent(id).subscribe(() => {
        this.loadEvents();
      });
    }
  }

  selectedEventId: number | null = null;

  selectEvent(eventId: number): void {
    this.selectedEventId = eventId;
  }

  // affichage participant


  toggleParticipants(eventId: number): void {
    this.selectedEventId = this.selectedEventId === eventId ? null : eventId;
  }

}
