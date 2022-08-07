//
//  LifeSpaceConsent.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 8/7/22.
//  Copyright © 2022 LifeSpace. All rights reserved.
//
import ResearchKit

class LifeSpaceConsent: ORKConsentDocument {

    override init() {
        super.init()

        let consentTitle = "LifeSpace Consent"
        title = NSLocalizedString(consentTitle, comment: "")
        sections = []

        // SECTION 1 - Description
        let descriptionSection = ORKConsentSection(type: .custom)
        descriptionSection.title = "Description"
        descriptionSection.formalTitle = "Description"
        let descriptionText = """
        You are invited to participate in a research study on life space, or the space within which people live, work, and recreate. Based on a custom iPhone Life Space application, we will develop individual life space maps (geographic footprint). We will sample Google Street View images from the life space and extract features using computer learning in order to evaluate the association of built environment features with health and well-being. This research study is looking for 120 REGARDS participants to be enrolled. Stanford University expects to enroll 120 research study participants.

        To participate in this study, you will download the LifeSpace App and complete the consent form. The LifeSpace App will passively capture your location for two weeks. Each evening, you will complete a brief survey of three questions. At the end of the data collection period, you will be sent an anonymous survey asking about your experiences using the app.
        """
        descriptionSection.summary = descriptionText
        descriptionSection.content = descriptionText

        sections?.append(descriptionSection)

        // SECTION 2 - RISKS AND BENEFITS
        let risksAndBenefitsSection = ORKConsentSection(type: .custom)
        risksAndBenefitsSection.title = "Risks and Benefits"
        risksAndBenefitsSection.formalTitle = "Risks and Benefits"
        let risksAndBenefitsText = """
        The primary risk associated with this study is a potential loss of privacy, and we have taken all measures to minimize this risk. If for any reason you do not wish to have your location recorded temporarily, you can toggle the “Track My Location” button and the app will stop recording until you start it again. Your data are stored securely, and your name and Apple ID will be removed from your data when it is downloaded.

        We cannot and do not guarantee or promise that you will receive any benefits from this study.
        """
        risksAndBenefitsSection.summary = risksAndBenefitsText
        risksAndBenefitsSection.content = risksAndBenefitsText

        sections?.append(risksAndBenefitsSection)

        // SECTION 3 - TIME INVOLVEMENT
        let timeInvolvementSection = ORKConsentSection(type: .custom)
        timeInvolvementSection.title = "Time Involvement"
        let timeInvolvementText = """
        Our LifeSpace App will passively capture location for a period of two weeks. Each evening, you will be asked to complete a brief survey of three questions (1-2 minutes). At the end of the data collection period, you will be sent a survey asking about your experiences using the app; this survey will take less than 10 minutes to complete.
        """
        timeInvolvementSection.summary = timeInvolvementText
        timeInvolvementSection.content = timeInvolvementText

        sections?.append(timeInvolvementSection)

        // SECTION 4 - PAYMENTS
        let paymentsSection = ORKConsentSection(type: .custom)
        paymentsSection.title = "Payments"
        let paymentsText = """
        You can receive up to $100 for your participation. You will receive $4/day for every day that you complete the survey for up to 14 days of participation and a bonus of $14 if you participate all 14 days. You will receive $30 for completion of the close out survey.
        """
        paymentsSection.summary = paymentsText
        paymentsSection.content = paymentsText

        sections?.append(paymentsSection)

        // SECTION 5 - PRIVACY AND DATA USE
        let privacyAndDataUseSection = ORKConsentSection(type: .custom)
        privacyAndDataUseSection.title = "Privacy And Data Use"
        let privacyAndDataUseText = """
        The information in this study will be used only for research purposes. This study is not anonymous. Your name will be shared with the investigators at the REGARDS Coordinating Center so they know that you are participating in this study and they will send us a study specific ID to be used only for this study. Your location data and data from the evening survey will deidentified and coded with this ID and stored at Stanford. Summary level data about your life space (such as the area in km2) will be shared with the REGARDS Coordinating Center using the study specific ID. These summary data will not contain any specific location data nor geographic identifiers. The summary level data will be linked to the other health data collected by REGARDS at the REGARDS Coordinating Center, and shared with Stanford. At no point will your location data or other personal identifiers be linked with your health data.
        """
        privacyAndDataUseSection.summary = privacyAndDataUseText
        privacyAndDataUseSection.content = privacyAndDataUseText

        sections?.append(privacyAndDataUseSection)

        // SECTION 6 - FUTURE USE OF PRIVATE INFORMATION
        let futureUseOfPrivateInformationSection = ORKConsentSection(type: .custom)
        futureUseOfPrivateInformationSection.title = "Future Use of Private Information"
        let futureUseOfPrivateInformationText = """
        Research using private information is an important way to try to understand human health.  You are being given this information because the investigators want to save private information for future research.
        Identifiers will be removed from identifiable private information and, after such removal, the information could be used for future research studies or distributed to another investigator for future research studies without additional informed consent from you.
        """
        futureUseOfPrivateInformationSection.summary = futureUseOfPrivateInformationText
        futureUseOfPrivateInformationSection.content = futureUseOfPrivateInformationText

        sections?.append(futureUseOfPrivateInformationSection)

        // SECTION 7 - PARTICIPANT'S RIGHTS
        let participantsRightsSection = ORKConsentSection(type: .custom)
        participantsRightsSection.title = "Participant's Rights"
        let participantsRightsText =  """
        If you have read this form and have decided to participate in this project, please understand your participation is voluntary and you have the right to withdraw your consent or discontinue participation at any time without penalty or loss of benefits to which you are otherwise entitled.
        Your decision whether or not to participate in this study will not affect your participation in the REGARDS study.
        You have the right to refuse to answer particular questions.
        The alternative to participating in this study is not to participate.
        The results of this research study may be presented at scientific or professional meetings or published in scientific journals.  However, your identity will not be disclosed.

        """
        participantsRightsSection.summary = participantsRightsText
        participantsRightsSection.content = participantsRightsText

        sections?.append(participantsRightsSection)

        // SECTION 8 - WITHDRAWAL FROM STUDY
        let withdrawalFromStudySection = ORKConsentSection(type: .custom)
        withdrawalFromStudySection.title = "Withdrawal from Study"
        let withdrawalFromStudyText = """
        If you first agree to participate and then you change your mind, you are free to withdraw your consent and discontinue your participation at any time.
        If you decide to withdraw your consent to participate in this study, you should notify Annabel Tan (annabelxtan@stanford.edu) or Michelle Odden (650-721-0230, modden@stanford.edu).
        If you decide to withdraw from the study, you can delete the LifeSpace App from your phone.
        The Protocol Director may also withdraw you from the study without your consent for one or more of the following reasons:
        • Failure to follow the instructions of the Protocol Director and study staff.
        • Unanticipated circumstances.
        """
        withdrawalFromStudySection.summary = withdrawalFromStudyText
        withdrawalFromStudySection.content = withdrawalFromStudyText

        sections?.append(withdrawalFromStudySection)

        // SECTION 9 - SPONSOR
        let sponsorSection = ORKConsentSection(type: .onlyInDocument)
        sponsorSection.title = "Sponsor"
        sponsorSection.formalTitle = "Sponsor"
        let sponsorSectionText = """
        Stanford University is providing financial support and/or material for this study.
        """
        sponsorSection.summary = sponsorSectionText
        sponsorSection.content = sponsorSectionText

        sections?.append(sponsorSection)

        // SECTION 10 - CONTACT INFORMATION
        let contactSection = ORKConsentSection(type: .onlyInDocument)
        contactSection.title = "Contact Information"
        let contactSectionText =  """
        Questions, Concerns, or Complaints: If you have any questions, concerns or complaints about this research study, its procedures, risks and benefits, you should ask the Protocol Director, Michelle Odden, (650) 721-0230. You should also contact her at any time if you feel you have been hurt by being a part of this study.
        Independent Contact:  If you are not satisfied with how this study is being conducted, or if you have any concerns, complaints, or general questions about the research or your rights as a participant, please contact the Stanford Institutional Review Board (IRB) to speak to someone independent of the research team at (650)-723-5244 or toll free at 1-866-680-2906.  You can also write to the Stanford IRB, Stanford University, 1705 El Camino Real, Palo Alto, CA 94306.
        """
        contactSection.summary = contactSectionText
        contactSection.content = contactSectionText

        sections?.append(contactSection)

        // SECTION 11 - SUMMARY
        let summarySection = ORKConsentSection(type: .onlyInDocument)
        summarySection.title = "Summary"
        summarySection.formalTitle = ""
        let summarySectionText = """
        A copy of this form is saved in your profile in the LifeSpace App – please print or save this locally to your iPhone. If you agree to participate in this research, please select the Agree button.
        """
        summarySection.content = summarySectionText

        sections?.append(summarySection)

        // SIGNATURE
        let signature = ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature")
        signature.title = title
        signaturePageTitle = title
        addSignature(signature)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
