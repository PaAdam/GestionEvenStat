import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { EventListComponent } from './components/event-list/event-list.component';

import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { ParticipantListComponent } from './components/participant-list/participant-list.component';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { StatistiquesComponent } from './components/statistiques/statistiques.component';

@NgModule({
  declarations: [
    AppComponent,
    EventListComponent,
    ParticipantListComponent,
    StatistiquesComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatTableModule,
    MatButtonModule ,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    MatFormFieldModule,
    MatInputModule,
    CommonModule,
    MatCardModule,
    MatSlideToggleModule,

  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
