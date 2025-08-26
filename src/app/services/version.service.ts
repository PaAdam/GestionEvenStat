import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class VersionService {
  private readonly version = '1.1.0';
  private readonly buildDate = new Date().toISOString();
  private readonly environment = 'production'; // Sera dynamique avec les environments

  constructor() { }

  getVersion(): string {
    return this.version;
  }

  getBuildDate(): string {
    return this.buildDate;
  }

  getEnvironment(): string {
    return this.environment;
  }

  getFullVersionInfo() {
    return {
      version: this.version,
      buildDate: this.buildDate,
      environment: this.environment,
      buildTime: new Date(this.buildDate).toLocaleString()
    };
  }

  isLatestVersion(): Promise<boolean> {
    // Simule une vérification de version (pourrait appeler une API)
    return Promise.resolve(true);
  }
}
