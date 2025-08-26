import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Participant } from '../models/participant';

@Injectable({
  providedIn: 'root',
})
export class ParticipantService {
  private apiUrl = 'http://localhost:3000/participants';

  constructor(private http: HttpClient) {}

  // Obtenir tous les participants
  getParticipants(): Observable<Participant[]> {
    return this.http.get<Participant[]>(this.apiUrl);
  }

  // Obtenir tous les participants d'un événement
  getParticipantsByEvent(eventId: number): Observable<Participant[]> {
    return this.http.get<Participant[]>(`${this.apiUrl}?eventId=${eventId}`);
  }

  // Ajouter un participant
  addParticipant(newParticipant: Participant): Observable<Participant> {
    return this.http.post<Participant>(this.apiUrl, newParticipant);
  }

  // Modifier un participant
  updateParticipant(participant: Participant): Observable<Participant> {
    return this.http.put<Participant>(`${this.apiUrl}/${participant.id}`, participant);
  }

  // Supprimer un participant
  deleteParticipant(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
