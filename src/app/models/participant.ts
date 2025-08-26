export class Participant {
    id?: number; // Identifiant unique (optionnel pour JSON Server)
    eventId!: number; // Référence à l'événement
    name!: string; // Nom
    email!: string; // Email
    phone!: string; // Numéro de téléphone
    presence: boolean = false; // Statut de présence (par défaut : absent)
  }
  