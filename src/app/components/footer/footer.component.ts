import { Component, OnInit } from '@angular/core';
import { VersionService } from '../../services/version.service';

@Component({
  selector: 'app-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.scss']
})
export class FooterComponent implements OnInit {
  versionInfo: any;
  currentYear = new Date().getFullYear();
  isOnline = navigator.onLine;

  constructor(private versionService: VersionService) { }

  ngOnInit(): void {
    this.versionInfo = this.versionService.getFullVersionInfo();
    
    // Écouter les changements de statut réseau
    window.addEventListener('online', () => this.isOnline = true);
    window.addEventListener('offline', () => this.isOnline = false);
  }

  getStatusColor(): string {
    return this.isOnline ? 'success' : 'warn';
  }

  getStatusText(): string {
    return this.isOnline ? 'En ligne' : 'Hors ligne';
  }
}
