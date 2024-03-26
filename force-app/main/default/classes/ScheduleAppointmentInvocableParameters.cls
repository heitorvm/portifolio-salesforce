global class ScheduleAppointmentInvocableParameters {

	@InvocableVariable
	public DateTime startDate;

	@InvocableVariable
	public DateTime endDate;

	@InvocableVariable
	public List<Decimal> days;

	@InvocableVariable
	public String shift;

	@InvocableVariable
	public Decimal physicianCRM;

	@InvocableVariable
	public decimal establishmentCode;

	@InvocableVariable
	public Insurance insurance;

	@InvocableVariable
	public Decimal naturalPersonCode;

	@InvocableVariable
	public String providerName;

	@InvocableVariable
	public String providerId;

	@InvocableVariable
	public String facilityName;

	@InvocableVariable
	public String facilityId;

	@InvocableVariable
	public String distance;

	@InvocableVariable
	public Decimal latitude;

	@InvocableVariable
	public Decimal longitude;

	@InvocableVariable
	public String patientId;

	@InvocableVariable
	public ObjectJS visitType;

	@InvocableVariable
	public List<String> specialties;

	@InvocableVariable
	public List<String> visitTypes;

	@InvocableVariable
	public List<ObjectJS> procedures;

	@InvocableVariable
	public List<Careprovider> careProviders;

	public class ObjectJS {

		@InvocableVariable
		public String value;

		@InvocableVariable
		public String id;

		@InvocableVariable
		public Decimal specialtyCode;

		@InvocableVariable
		public Decimal duration;

		@InvocableVariable
		public Decimal internalProcedureCode;

	}

	public class Insurance {

		@InvocableVariable
		public String code;

		@InvocableVariable
		public String category;

		@InvocableVariable
		public String plan;

	}

	public class visitType {

		@InvocableVariable
		public Decimal specialtyCode;

		@InvocableVariable
		public Decimal duration;
	}

	public class Procedure {

		@InvocableVariable
		public Decimal internalProcedureCode;

		@InvocableVariable
		public Decimal duration;

	}

	public class CareProvider {
		public String careProviderId;
		public String sourceFacilityId;
		public String sourcePractitionerId;
		public String appointmentType;
		public String practitionerFacilityId;
	}
}