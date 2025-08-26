import { Component, Input, OnInit } from '@angular/core';
import { ParticipantService } from '../../services/participant.service';
import { Participant } from '../../models/participant';

@Component({
  selector: 'app-participant-list',
  templateUrl: './participant-list.component.html',
  styleUrls: ['./participant-list.component.css']
})
export class ParticipantListComponent implements OnInit {
  @Input() eventId!: number;
  participants: Participant[] = [];
  newParticipant: Participant = { id: 0, name: '', email: '', phone: '', presence: false, eventId: 0 };

  constructor(private participantService: ParticipantService) {}

  ngOnInit(): void {
    this.loadParticipants();
  }

  loadParticipants(): void {
    if (this.eventId) {
      this.participantService.getParticipantsByEvent(this.eventId).subscribe(data => {
        this.participants = data;
      });
    }
  }

  addParticipant(): void {
    if (!this.newParticipant.name || !this.newParticipant.email || !this.newParticipant.phone) return;

    this.newParticipant.eventId = this.eventId;
    this.participantService.addParticipant(this.newParticipant).subscribe(() => {
      this.loadParticipants();
      this.newParticipant = { id: 0, name: '', email: '', phone: '', presence: false, eventId: 0 };
    });
  }

  togglePresence(participant: Participant): void {
    participant.presence = !participant.presence;
    this.participantService.updateParticipant(participant).subscribe();
  }

  deleteParticipant(participantId: number): void {
    this.participantService.deleteParticipant(participantId).subscribe(() => {
      this.participants = this.participants.filter(p => p.id !== participantId);
    });
  }
}
