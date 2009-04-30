using System.Collections.Generic;
using NUnit.Framework;

namespace SharpInflection
{
    [TestFixture]
    public class Tests
    {
        
        [Test]
        public void TestCamelize()
        {
            var CamelToUnderscore = new Dictionary<string, string> 
                                        { 
                                            {"Product", "product"},
                                            {"SpecialGuest" , "special_guest"},
                                            {"ApplicationController", "application_controller"},
                                            {"Area51Controller", "area51_controller"}
                                        };

            foreach (var pair in CamelToUnderscore)
            {
                Assert.AreEqual(pair.Key, Inflector.camelize(pair.Value));    
            }
            
        }
    }
}