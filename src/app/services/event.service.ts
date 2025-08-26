import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Event } from '../models/event';

@Injectable({
  providedIn: 'root'
})
export class EventService {
  private apiUrl = 'http://localhost:3000/events';  // URL de JSON Server

  constructor(private http: HttpClient) {}

  // Obtenir la liste des événements
  getEvents(): Observable<Event[]> {
    return this.http.get<Event[]>(this.apiUrl);
  }

  // Supprimer un événement
  deleteEvent(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }

  // Ajouter un événement
  addEvent(event: Event): Observable<Event> {
    return this.http.post<Event>(this.apiUrl, event);
  }

  // Ajout de la méthode pour mettre à jour un événement
  updateEvent(event: Event): Observable<Event> {
    return this.http.put<Event>(`${this.apiUrl}/${event.id}`, event);
  }

  getParticipantsByEvent(eventId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/participants?eventId=${eventId}`);
  }

}
