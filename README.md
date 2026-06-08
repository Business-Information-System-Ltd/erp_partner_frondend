<!-- # partner_demo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference. -->

# BizSoft ERP Partner UI

## Overview

This feature implements the common Business Partner / Stakeholder master data UI for a Flutter web ERP application. It consumes the Django Partner API and intentionally does not implement Customer, Supplier, Employee, Fixed Asset Register, Finance, or other module-specific profiles.

## Screens

- `PartnerListScreen`: browse, search, filter, open detail, and open edit.
- `PartnerFormScreen`: create and edit partners using tabbed sections.
- `PartnerDetailScreen`: read-only summary and child-record browsing.

## Folder Structure

- `domain/enums`: Partner enum values and API mapping helpers.
- `domain/models`: Partner aggregate and child-record models.
- `data/services`: Dio API service.
- `data/repositories`: Repository pattern conversion layer.
- `presentation/providers`: Riverpod state and dependency providers.
- `presentation/widgets`: Reusable Partner form, lookup, chip, and child-section widgets.
- `presentation/screens`: Routed list, form, and detail screens.

## API

The UI expects these Django endpoints:

- `GET /api/partners/`
- `POST /api/partners/`
- `GET /api/partners/{id}/`
- `PUT /api/partners/{id}/`
- `PATCH /api/partners/{id}/`
- `POST /api/partners/{id}/activate/`
- `POST /api/partners/{id}/block/`
- `GET/POST /api/partners/{id}/{child-name}/`

Set the backend URL at run time:

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

## Flow

The default route is `/partners`. The user can search and filter partners, create a new draft, edit an existing partner, activate it, block it, or view read-only detail. Child tabs are visible during create/edit, but child add actions are disabled until the Partner has been saved and has an id.

## Validation

The form validates required common fields before saving:

- Display Name
- Country Code
- Default Currency

Backend validation errors are normalized by `ApiClient` and shown through provider error state.

## State

Riverpod providers manage:

- `partnerListProvider`: list, filters, paging, loading, and error state.
- `partnerDetailProvider`: async detail fetch by id.
- `partnerFormProvider`: create/edit dirty state, save state, validation errors, success, activate, and block actions.
- `partnerRepositoryProvider` and `partnerApiServiceProvider`: dependency setup.

## Run

Install dependencies:

```powershell
flutter pub get
```

Run for web:

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

## Routes

- `/partners`
- `/partners/new`
- `/partners/:id`
- `/partners/:id/edit`

## Future Extensions

- Add child-record create/edit dialogs for roles, addresses, contacts, registrations, identifications, relationships, and compliance.
- Add server-side sorting and page-size controls.
- Add audit/log panels.
- Add permission-based button visibility.
- Add module-specific navigation into Customer, Supplier, Employee, FAR, and Finance profiles after Partner activation.
