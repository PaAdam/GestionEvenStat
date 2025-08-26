import { Component, AfterViewInit, ElementRef, ViewChild, OnInit } from '@angular/core';
import Chart from 'chart.js/auto';
import { EventService } from 'src/app/services/event.service';

@Component({
  selector: 'app-statistiques',
  templateUrl: './statistiques.component.html',
  styleUrls: ['./statistiques.component.scss']
})
export class StatistiquesComponent implements OnInit, AfterViewInit {
  @ViewChild('barCanvas') barCanvas!: ElementRef;

  totalEvents: number = 0;
  eventLabels: string[] = [];
  participantsData: number[] = [];

  constructor(private eventService: EventService) {}

  ngOnInit(): void {
    this.loadStatistics();
  }

  ngAfterViewInit(): void {
    setTimeout(() => {
      this.createChart();
    }, 500);
  }

  loadStatistics(): void {
    this.eventService.getEvents().subscribe(events => {
      this.totalEvents = events.length;
      this.eventLabels = events.map(event => event.name);

      let participantCounts: number[] = new Array(events.length).fill(0);

      events.forEach((event, index) => {
        if (event.id) {  // Ajoute une vérification pour éviter undefined
          this.eventService.getParticipantsByEvent(event.id).subscribe(participants => {
            participantCounts[index] = participants.length;

            if (index === events.length - 1) {
              this.participantsData = participantCounts;
              this.createChart();
            }
          });
        }
      });
    });
  }

  createChart(): void {
    new Chart(this.barCanvas.nativeElement, {
      type: 'bar',
      data: {
        labels: this.eventLabels,
        datasets: [{
          label: 'Nombre de participants',
          data: this.participantsData,
          backgroundColor: ['red', 'blue', 'green', 'orange', 'purple']
        }]
      },
      options: {
        responsive: true
      }
    });
  }
}
