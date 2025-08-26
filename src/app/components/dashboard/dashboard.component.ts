import { Component, OnInit } from '@angular/core';
import { EventService } from '../../services/event.service';
import { ParticipantService } from '../../services/participant.service';
import { VersionService } from '../../services/version.service';
import { Event } from '../../models/event';
import { Participant } from '../../models/participant';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  stats = {
    totalEvents: 0,
    totalParticipants: 0,
    recentEvents: 0,
    avgParticipantsPerEvent: 0
  };

  versionInfo: any;

  constructor(
    private eventService: EventService,
    private participantService: ParticipantService,
    private versionService: VersionService
  ) { }

  ngOnInit(): void {
    this.loadStats();
    this.versionInfo = this.versionService.getFullVersionInfo();
  }

  loadStats(): void {
    // Charger les statistiques globales
    this.eventService.getEvents().subscribe((events: Event[]) => {
      this.stats.totalEvents = events.length;
      
      // Calculer les événements récents (derniers 30 jours)
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      
      this.stats.recentEvents = events.filter(event => 
        new Date(event.date) > thirtyDaysAgo
      ).length;
    });

    this.participantService.getParticipants().subscribe((participants: Participant[]) => {
      this.stats.totalParticipants = participants.length;
      
      if (this.stats.totalEvents > 0) {
        this.stats.avgParticipantsPerEvent = Math.round(
          this.stats.totalParticipants / this.stats.totalEvents
        );
      }
    });
  }
}
