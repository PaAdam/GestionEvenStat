import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EventListComponent } from './components/event-list/event-list.component';

const routes: Routes = [
  { path: 'events', component: EventListComponent },  // Ajout de la route pour le composant
  { path: '', redirectTo: '/events', pathMatch: 'full' },  // Redirection vers /events par défaut
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
