//
//  ArticleViewController.swift
//  noteBook
//
//  Created by rdm10 on 09/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var articleTitle: UITextView!
    @IBOutlet weak var articleUrl: UITextView!
    @IBOutlet weak var articleBody: UITextView!
    @IBOutlet weak var articleWordCount: UILabel!
    @IBOutlet weak var articleScore: UILabel!
    @IBOutlet weak var articleStarRating: UILabel!
    @IBOutlet weak var articleTrailText: UILabel!
    
    var articleResult: GuardianOpenPlatformResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unpackResult()
        // Do any additional setup after loading the view.
    }
    
    func unpackResult(){
        articleTitle.text = articleResult.webTitle
        resize(textView: articleTitle)
        articleUrl.text = (articleResult.webUrl)?.absoluteString
        resize(textView: articleUrl)
        articleBody.text = """
        In the June of 1942 she had been in the Royal Albert Hall for the concert premiere of the Seventh Symphony, the ‘Leningrad’.  A man she knew had finessed a ticket for her.  The Hall had been packed to the rafters and the atmosphere had been electrifying, magnificent - it had felt as though they were at one with the occupants of the siege.  And with Shostakovich too.  A collective swelling of the heart.  So long ago.  So meaningless now. The Russians had been their enemies and then they were their allies, and then they were enemies again.  The Germans the same - the great enemy, the worst of all of them, and now they were our friends, one of the mainstays of Europe.  It was all such a waste of breath.  War and peace.  Peace and war.  It would go on forever without end.
        ‘Miss Armstrong, I’m just going to put this neck collar on you.’
        She found herself thinking about her son.  Matteo.  He was twenty-six years old, the result of a brief liaison with an Italian musician – she had lived in Italy for many years.  Juliet’s love for Matteo had been one of the overwhelming wonders of her life.  She was worried for him - he was living in Milan with a girl who made him unhappy and she was fretting over this when the car hit her.
        Lying on the pavement of Wigmore Street with concerned bystanders all around she knew there was no way out from this.  She was just sixty years old, although it had probably been a long enough life.  Yet suddenly  it all seemed like an illusion, a dream that had happened to someone else.  What an odd thing existence was.
        There was to be a royal wedding.  Even now, as she lay on this London pavement with these kind strangers around her, a sacrificial virgin was being prepared somewhere up the road, to satisfy the need for pomp and circumstance.   Union Jacks draped everywhere.  There was no mistaking that she was home.  At last.
        ‘This England,’ she murmured.
        1950
        Mr Toby! Mr Toby!
        Juliet came up from the Underground and made her way along Great Portland Street.  Checking her watch she saw that she was surprisingly late for work.  She had overslept, a result of a late evening in the Belle Meunière in Charlotte Street with a man who had proved less and less interesting as the night had worn on.  Inertia – or ennui perhaps - had kept her at the table, although the house specialities of ‘Viane de boeuf Diane’ and Crepe Suzette had helped.
        Her rather lacklustre dinner companion was an architect who said he was ‘rebuilding post-war London.’  All on your own? she had asked, rather unkindly.  She allowed him a – brief – kiss as he handed her into a taxi at the end of the night.  From politeness rather than desire.  He had paid for the dinner after all and she had been unnecessarily mean to him although he hadn’t seemed to notice.  The whole evening had left her feeling rather sour.  I am a disappointment to myself, she thought as Broadcasting House hove into view.
        Juliet was a producer in Schools and as she approached Portland Place she found her spirits drooping at the prospect of the rather tedious day ahead – a departmental meeting with Prendergast, followed by a recording of Past Lives, a series she was looking after for Joan Timpson who was having an operation (‘Just a small one, dear.’).
        Schools had recently had to move from the basement of Film House in Wardour Street and Juliet missed the dilapidated raffishness of Soho.  The BBC didn’t have room for them in Broadcasting House so they had been parked across the road in No 1 and gazed, not without envy, at their mother-ship, the great, many-decked ocean liner of Broadcasting House, scrubbed clean now of its wartime camouflage and thrusting its prow into a new decade and an unknown future.
        Unlike the non-stop to and fro across the road, the Schools’ building was quiet when Juliet entered. The carafe of red wine that she had shared with the architect had left her with a very dull head and it was a relief not to have to partake of the usual exchange of morning greetings.  The girl on reception looked rather pointedly at the clock when she saw Juliet coming through the door.  The girl was having an affair with a producer in the World Service and  seemed to think it gave her licence to be brazen.  The girls on Schools’ reception came and went with astonishing rapidity. Juliet liked to imagine they were being eaten by something monstrous, a minotaur perhaps, in the mazy bowels of the building, although actually they were simply transferring to more glamorous departments across the road in Broadcasting House.
        ‘The Circle line was running late,’ Juliet said, although she hardly felt she needed to give the girl an explanation, true or otherwise.
        ‘Again?’
        """
        resize(textView: articleBody)
    }
    
    func resize(textView: UITextView){
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
